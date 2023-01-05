class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://github.com/phusion/passenger/releases/download/release-6.0.16/passenger-6.0.16.tar.gz"
  sha256 "f2a4e9d718e62cc4aca5f03ed461cca14eb0c383d2bd96f47cebcc40b619873a"
  license "MIT"
  revision 1
  head "https://github.com/phusion/passenger.git", branch: "stable-6.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0530d88e1bfb10c3ab7c3bc20bed926117a83dcf234176ea855f0d8ecb6b883d"
    sha256 cellar: :any,                 arm64_monterey: "ccd14adb88052d8b57c53208db1af3e9fdea130e3fbdc6559ab671982fc323a6"
    sha256 cellar: :any,                 arm64_big_sur:  "1ddd2dc4815701074805ce4200339050fbffd2da0fe0263381cfc0a5ae07fab6"
    sha256 cellar: :any,                 ventura:        "591107e61af265eea23de509e28b6be07056d197c4610f57021153f7dc47c85d"
    sha256 cellar: :any,                 monterey:       "3fc42d7a84fe245612b8afe8bd8d5c4cfddd1e68456e236ba173ad9b9a5a7022"
    sha256 cellar: :any,                 big_sur:        "752bb485c6a9d6cbffef16abe5a631e3ee48b18a18244568640dbd16a35c3d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09db4ff74f39cdcdc2c4a1a3b5c616735574c67aa844572cdff48bdf167ed5ff"
  end

  depends_on "httpd" => :build # to build the apache2 module
  depends_on "nginx" => [:build, :test] # to build nginx module
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@1.1"
  depends_on "pcre"

  uses_from_macos "xz" => :build
  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "ruby", since: :catalina

  # Fix compatibility with Ruby 3.2.
  # Remove after next 6.0.17 release.
  patch :DATA

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    else
      ENV.delete("SDKROOT")
    end

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

    cp_r necessary_files, libexec, preserve: true

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
    cp Dir["buildout/support-binaries/nginx*"], libexec/"buildout/support-binaries", preserve: true

    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    man1.install Dir["man/*.1"]
    man8.install Dir["man/*.8"]

    # See https://github.com/Homebrew/homebrew-core/pull/84379#issuecomment-910179525
    deuniversalize_machos
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
        passenger_temp_path #{testpath}/passenger_temp;

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
__END__
diff --git a/src/ruby_native_extension/extconf.rb b/src/ruby_native_extension/extconf.rb
index 95964c5f1..09c820d51 100644
--- a/src/ruby_native_extension/extconf.rb
+++ b/src/ruby_native_extension/extconf.rb
@@ -24,7 +24,7 @@
 
 # Apple has a habit of getting their Ruby headers wrong, so if we are building using system ruby we need to patch things up, sierra & mojave both did this.
 # eg https://openradar.appspot.com/46465917
-if RUBY_PLATFORM =~ /darwin/ && !File.exists?(RbConfig::CONFIG["rubyarchhdrdir"])
+if RUBY_PLATFORM =~ /darwin/ && !File.exist?(RbConfig::CONFIG["rubyarchhdrdir"])
   RbConfig::CONFIG["rubyarchhdrdir"].sub!(RUBY_PLATFORM.split('-').last, Dir.entries(File.dirname(RbConfig::CONFIG["rubyarchhdrdir"])).reject{|d|d.start_with?(".","ruby")}.first.split('-').last)
 end
 
diff --git a/src/ruby_supportlib/phusion_passenger/platform_info/operating_system.rb b/src/ruby_supportlib/phusion_passenger/platform_info/operating_system.rb
index de17c072a..ecc24b710 100644
--- a/src/ruby_supportlib/phusion_passenger/platform_info/operating_system.rb
+++ b/src/ruby_supportlib/phusion_passenger/platform_info/operating_system.rb
@@ -247,7 +247,7 @@ def self.supports_lfence_instruction?
     memoize :supports_lfence_instruction?, true
 
     def self.requires_no_tls_direct_seg_refs?
-      return File.exists?("/proc/xen/capabilities") && cpu_architectures[0] == "x86"
+      return File.exist?("/proc/xen/capabilities") && cpu_architectures[0] == "x86"
     end
     memoize :requires_no_tls_direct_seg_refs?, true
 
