# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'hack_test'
set :repo_url, 'git@github.com:yaonie084/hack_test.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/root/sites'

set :keep_releases, 2

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -f #{full_path} ]; then echo 'true';fi").strip
end


namespace :deploy do

  desc 'Restart application'
  remote_config_url =  "http://7u2o75.com1.z0.glb.clouddn.com/config.json.png"
  config_file_name = "config.json"
  start = "start server.coffee -i max --interpreter coffee"
  reload = "reload all"
  restart = "restart all"
  update = "updatePM2"
  stop = "stop all"
  delete = "delete all"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      within release_path do
        execute :npm, "install"
        execute :wget, "#{remote_config_url} -O #{config_file_name}"
        execute :gulp
        execute :pm2, stop
        execute :pm2, delete
        execute :pm2, update
        execute :pm2, start
      end
    end
  end

  task :gulp_installer do
    on roles(:app), in: :sequence, wait: 5 do
        unless remote_file_exists? "/usr/bin/gulp"
          execute :npm, "install -g gulp"
        end
    end
  end

  after :publishing, :gulp_installer
  after :gulp_installer, :restart

end
