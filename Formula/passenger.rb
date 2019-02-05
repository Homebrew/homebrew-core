class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://github.com/phusion/passenger/releases/download/release-6.0.1/passenger-6.0.1.tar.gz"
  sha256 "038be424e30a850f340285371419a9bbf236d103f81c79d50e2807bb335502e5"
  head "https://github.com/phusion/passenger.git", :branch => "stable-6.0"

  bottle do
    cellar :any
    sha256 "c8df29e4977d5e7495ac2bca1a5299a38a361955014e2ccb200f6495b2dee464" => :mojave
    sha256 "4cd91a1f49d517eb4752bfe0c328f97c040a6bde02200863009c3e61bd329eb6" => :high_sierra
    sha256 "d094cecf62e66a527482b681bdfa01cc7fa956a16ad9e4d2fea520ffc63cac6f" => :sierra
  end

  depends_on "nginx" => :build # for configure arguments
  depends_on "openssl"
  depends_on "pcre"

  # must match nginx formula
  resource "nginx" do
    url "https://nginx.org/download/nginx-1.15.8.tar.gz"
    sha256 "a8bdafbca87eb99813ae4fcac1ad0875bf725ce19eb265d28268c309b2b40787"
  end

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    inreplace "src/ruby_supportlib/phusion_passenger/platform_info/openssl.rb" do |s|
      s.gsub! "-I/usr/local/opt/openssl/include", "-I#{Formula["openssl"].opt_include}"
      s.gsub! "-L/usr/local/opt/openssl/lib", "-L#{Formula["openssl"].opt_lib}"
    end

    system "rake", "apache2"
    system "rake", "nginx"
    nginx_addon_dir = `/usr/bin/ruby ./bin/passenger-config about nginx-addon-dir`.strip
    resource("nginx").stage do
      _, stderr, = Open3.capture3("nginx", "-V")
      args = stderr.split("configure arguments:").last.split(" --").reject(&:empty?).map { |s| "--#{s.strip}" }
      args << "--add-dynamic-module=#{nginx_addon_dir}"

      system "./configure", *args

      system "make"

      (libexec/"buildout/nginx_dynamic/").mkpath
      cp "objs/ngx_http_passenger_module.so", libexec/"buildout/nginx_dynamic/"
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

    locations_ini = `/usr/bin/ruby ./bin/passenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(/=#{Regexp.escape Dir.pwd}/, "=#{libexec}")
    (libexec/"src/ruby_supportlib/phusion_passenger/locations.ini").write(locations_ini)

    ruby_libdir = `/usr/bin/ruby ./bin/passenger-config about ruby-libdir`.strip
    ruby_libdir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--ruby", ruby_libdir, *Dir[libexec/"bin/*"]

    system("/usr/bin/ruby ./bin/passenger-config compile-nginx-engine")
    cp Dir["buildout/support-binaries/nginx*"], libexec/"buildout/support-binaries", :preserve => true

    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    man1.install Dir["man/*.1"]
    man8.install Dir["man/*.8"]
  end

  def caveats; <<~EOS
    To activate Phusion Passenger for Nginx, run:
      brew install nginx
    And add the following to #{etc}/nginx/nginx.conf at the top scope (outside http{}):
      load_module #{opt_libexec}/buildout/nginx_dynamic/ngx_http_passenger_module.so;
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
  end
end
