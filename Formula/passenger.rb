class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://github.com/phusion/passenger/releases/download/release-6.0.4/passenger-6.0.4.tar.gz"
  sha256 "ec1e4b555c176642c1c316897177d54b6f7d369490280e8ee3e54644e40b250b"
  head "https://github.com/phusion/passenger.git", :branch => "stable-6.0"

  bottle do
    cellar :any
    sha256 "24321dbcff81680db700a4db7b51ec3e0f3ac0b529da65472dc31d16cb2274ec" => :mojave
    sha256 "ed377d83606fa170504a5eef8616e565a3bd13a9df2039ad6b512aa11356ef65" => :high_sierra
    sha256 "0953ddc8a300558ce56392181435f98760afa469fd12bbe4664ddaa471c7e8ff" => :sierra
  end

  # to build nginx module
  depends_on "nginx" => [:build, :test]
  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    inreplace "src/ruby_supportlib/phusion_passenger/platform_info/openssl.rb" do |s|
      s.gsub! "-I/usr/local/opt/openssl/include", "-I#{Formula["openssl@1.1"].opt_include}"
      s.gsub! "-L/usr/local/opt/openssl/lib", "-L#{Formula["openssl@1.1"].opt_lib}"
    end

    system "rake", "apache2"
    system "rake", "nginx"
    nginx_addon_dir = `./bin/passenger-config about nginx-addon-dir`.strip

    mkdir "nginx" do
      system "tar", "-xf", "#{Formula["nginx"].opt_pkgshare}/src/src.tar.xz", "--strip-components", "1"
      args = (Formula["nginx"].opt_pkgshare/"src/configure_args.txt").read.split("\n")
      args << "--add-dynamic-module=#{nginx_addon_dir}"

      system "./configure", *args
      system "make"
      (libexec/"modules").install "objs/ngx_http_passenger_module.so"
    end

    (libexec/"download_cache").mkpath

    # Fixes https://github.com/phusion/passenger/issues/1288
    rm_rf "buildout/libev"
    rm_rf "buildout/libuv"
    rm_rf "buildout/cache"

    necessary_files = %w[configure Rakefile README.md CONTRIBUTORS
                         CONTRIBUTING.md LICENSE CHANGELOG package.json
                         passenger.gemspec build bin doc images dev src
                         resources buildout]

    cp_r necessary_files, libexec, :preserve => true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Ensure that the Phusion Passenger commands can always find their library
    # files.

    locations_ini = `./bin/passenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(/=#{Regexp.escape Dir.pwd}/, "=#{libexec}")
    (libexec/"src/ruby_supportlib/phusion_passenger/locations.ini").write(locations_ini)

    ruby_libdir = `./bin/passenger-config about ruby-libdir`.strip
    ruby_libdir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "./dev/install_scripts_bootstrap_code.rb",
      "--ruby", ruby_libdir, *Dir[libexec/"bin/*"]

    system "./bin/passenger-config", "compile-nginx-engine"
    cp Dir["buildout/support-binaries/nginx*"], libexec/"buildout/support-binaries", :preserve => true

    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    man1.install Dir["man/*.1"]
    man8.install Dir["man/*.8"]
  end

  def caveats; <<~EOS
    To activate Phusion Passenger for Nginx, run:
      brew install nginx
    And add the following to #{etc}/nginx/nginx.conf at the top scope (outside http{}):
      load_module #{opt_libexec}/modules/ngx_http_passenger_module.so;
    And add the following to #{etc}/nginx/nginx.conf in the http scope:
      passenger_root #{opt_libexec}/src/ruby_supportlib/phusion_passenger/locations.ini;
      passenger_ruby /usr/bin/ruby;

    To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
      LoadModule passenger_module #{opt_libexec}/buildout/apache2/mod_passenger.so
      PassengerRoot #{opt_libexec}/src/ruby_supportlib/phusion_passenger/locations.ini
      PassengerDefaultRuby /usr/bin/ruby
  EOS
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}/bin/passenger-config --ruby-libdir`.strip
    assert_equal "#{libexec}/src/ruby_supportlib", ruby_libdir

    (testpath/"nginx.conf").write <<~EOS
      load_module #{opt_libexec}/modules/ngx_http_passenger_module.so;
      worker_processes 4;
      error_log #{testpath}/error.log;
      pid #{testpath}/nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        passenger_root #{opt_libexec}/src/ruby_supportlib/phusion_passenger/locations.ini;
        passenger_ruby /usr/bin/ruby;
        client_body_temp_path #{testpath}/client_body_temp;
        fastcgi_temp_path #{testpath}/fastcgi_temp;
        proxy_temp_path #{testpath}/proxy_temp;
        scgi_temp_path #{testpath}/scgi_temp;
        uwsgi_temp_path #{testpath}/uwsgi_temp;

        server {
          passenger_enabled on;
          listen 8080;
          root #{testpath};
          access_log #{testpath}/access.log;
          error_log #{testpath}/error.log;
        }
      }
    EOS
    system "#{Formula["nginx"].opt_bin}/nginx", "-t", "-c", testpath/"nginx.conf"
  end
end
