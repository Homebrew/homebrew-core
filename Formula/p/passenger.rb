class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://github.com/phusion/passenger/releases/download/release-6.2.2/passenger-6.2.2.tar.gz"
  sha256 "753e74b89ffc7e0e9525b00c936d71da28f279f849e94781be72e7c19c617994"
  license "MIT"
  revision 2
  head "https://github.com/phusion/passenger.git", branch: "stable-6.2"

  bottle do
    manifest_sha256 "8de5cb09bb26dbdb345bc0b224b22975c99a322b65353193bdcdd614327eef70"
    sha256 cellar: :any, arm64_golden_gate: "4262cf895100b6f04bfd0893e43cdaa49ffb164b58c2a7a63687019acb254575"
    sha256 cellar: :any, arm64_tahoe:       "5f189ba2207857686966fab505052ed6344a752e8c07106148c21612ba984869"
    sha256 cellar: :any, arm64_sequoia:     "1e787111d1e7ed0cf035a74916110e6457e62b412cbcba4944434c59e8c0de9d"
    sha256 cellar: :any, arm64_linux:       "60e71b08ecd397eb7636e76e1534d07683582a9eab1c6455d98b1de41f96e4cc"
    sha256 cellar: :any, x86_64_linux:      "79062fe262df3487aafc39f263a6b8e4819b20e6d492c981b835f30dd033b230"
  end

  depends_on "httpd" => :build # to build the apache2 module
  depends_on "nginx" => [:build, :test] # to build nginx module
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@4"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "ruby"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    if OS.mac? && MacOS::CLT.installed?
      ENV["SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    else
      ENV.delete("SDKROOT")
    end

    inreplace "src/ruby_supportlib/phusion_passenger/platform_info/openssl.rb" do |s|
      openssl = dep("openssl")
      s.gsub! "-I/usr/local/opt/openssl/include", "-I#{openssl.opt_include}"
      s.gsub! "-L/usr/local/opt/openssl/lib", "-L#{openssl.opt_lib}"
    end

    system "rake", "apache2"
    system "rake", "nginx"
    nginx_addon_dir = `./bin/passenger-config about nginx-addon-dir`.strip
    nginx = Formula["nginx"]

    mkdir "nginx" do
      system "tar", "-xf", "#{nginx.opt_pkgshare}/src/src.tar.xz", "--strip-components", "1"
      args = (nginx.opt_pkgshare/"src/configure_args.txt").read.split("\n")
      args << "--add-dynamic-module=#{nginx_addon_dir}"

      system "./configure", *args
      system "make"
      (libexec/"modules").install "objs/ngx_http_passenger_module.so"
    end

    (libexec/"download_cache").mkpath

    # Fixes https://github.com/phusion/passenger/issues/1288
    rm_r("buildout/libev")
    rm_r("buildout/libuv")
    rm_r("buildout/cache")

    necessary_files = %w[configure Rakefile README.md CONTRIBUTORS
                         CONTRIBUTING.md LICENSE CHANGELOG package.json
                         passenger.gemspec build bin doc images dev src
                         resources buildout]

    cp_r necessary_files, libexec, preserve: true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.install_symlink libexec.glob("bin/*")

    # Ensure that the Phusion Passenger commands can always find their library
    # files.

    locations_ini = `./bin/passenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(/=#{Regexp.escape Dir.pwd}/, "=#{libexec}")
    (libexec/"src/ruby_supportlib/phusion_passenger/locations.ini").write(locations_ini)

    ruby_libdir = `./bin/passenger-config about ruby-libdir`.strip
    ruby_libdir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "./dev/install_scripts_bootstrap_code.rb",
      "--ruby", ruby_libdir, *Dir[libexec/"bin/*"]

    # Recreate the tarball with a top-level directory, and use Gzip compression.
    mkdir "nginx-#{nginx.version}" do
      system "tar", "-xf", "#{nginx.opt_pkgshare}/src/src.tar.xz", "--strip-components", "1"
    end
    system "tar", "-czf", buildpath/"nginx.tar.gz", "nginx-#{Formula["nginx"].version}"

    system "./bin/passenger-config", "compile-nginx-engine",
      "--nginx-tarball", buildpath/"nginx.tar.gz",
      "--nginx-version", nginx.version.to_s
    cp Dir["buildout/support-binaries/nginx*"], libexec/"buildout/support-binaries", preserve: true

    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    man1.install Dir["man/*.1"]
    man8.install Dir["man/*.8"]
  end

  def caveats
    <<~EOS
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

    (testpath/"nginx.conf").write <<~CONF
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
        passenger_temp_path #{testpath}/passenger_temp;

        server {
          passenger_enabled on;
          listen 8080;
          root #{testpath};
          access_log #{testpath}/access.log;
          error_log #{testpath}/error.log;
        }
      }
    CONF
    system "#{formula_opt_bin("nginx")}/nginx", "-t", "-c", testpath/"nginx.conf"
  end
end
