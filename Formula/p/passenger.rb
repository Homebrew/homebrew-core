class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://github.com/phusion/passenger/releases/download/release-6.1.8/passenger-6.1.8.tar.gz"
  sha256 "86fdafdc0e02da8f4120a3e518e7ce3b2db0199b8c0cdfc46865240e8ebfc32d"
  license "MIT"
  head "https://github.com/phusion/passenger.git", branch: "stable-6.1"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d329f12d3f14ce414c967e11d2d900a1e24edb7860324f77b47b535b88af93b"
    sha256 cellar: :any, arm64_sequoia: "480a8cab3f08b1dfa83a7ab6c445260a08795bdbb8161aecdbb20171581f4615"
    sha256 cellar: :any, arm64_sonoma:  "15708781aa99caeaa447f30c2e78107b68192c2ac3460fd8c7c20434a058e035"
    sha256 cellar: :any, sonoma:        "8a61cac9cddaae4173f816a1110f59202d022fcc7f0f428c77be15f00a63a61b"
    sha256 cellar: :any, arm64_linux:   "6af549f9cb6b92b6e20252b7a7275c7315014db2fe8c9bfd0f3154f079d34fc7"
    sha256 cellar: :any, x86_64_linux:  "c17157bbac05d865403e3202ee8fbb344610b9e00c60db4f6379041020eab9a6"
  end

  depends_on "httpd" => :build # to build the apache2 module
  depends_on "nginx" => [:build, :test] # to build nginx module
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "ruby"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.mac? && MacOS::CLT.installed?
      ENV["SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    else
      ENV.delete("SDKROOT")
    end

    inreplace "src/ruby_supportlib/phusion_passenger/platform_info/openssl.rb" do |s|
      s.gsub! "-I/usr/local/opt/openssl/include", "-I#{formula_opt_include("openssl@3")}"
      s.gsub! "-L/usr/local/opt/openssl/lib", "-L#{formula_opt_lib("openssl@3")}"
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
    mkdir "nginx-#{Formula["nginx"].version}" do
      system "tar", "-xf", "#{Formula["nginx"].opt_pkgshare}/src/src.tar.xz", "--strip-components", "1"
    end
    system "tar", "-czf", buildpath/"nginx.tar.gz", "nginx-#{Formula["nginx"].version}"

    system "./bin/passenger-config", "compile-nginx-engine",
      "--nginx-tarball", buildpath/"nginx.tar.gz",
      "--nginx-version", Formula["nginx"].version.to_s
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
