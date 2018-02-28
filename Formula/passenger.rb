class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://s3.amazonaws.com/phusion-passenger/releases/passenger-5.2.1.tar.gz"
  sha256 "d725a705124dad1ae9a4ce61d76566061dc80abd4ec7a652489f09a8de60e481"
  head "https://github.com/phusion/passenger.git", :branch => "stable-5.1"

  bottle do
    sha256 "8e12133a04a8c77ab1362c8b08494fbff9e567a8ad97d22546a5bb5f0f311273" => :high_sierra
    sha256 "78e7b4f034822bb27022f9d747c183c7ad773cb8feb465c3fd6751338736df84" => :sierra
    sha256 "f78e43bc318f260129579331416edc74ccbd965fb3a89617024e1f37949aa740" => :el_capitan
  end

  option "without-apache2-module", "Disable Apache2 module"

  depends_on :macos => :lion
  depends_on "pcre"
  depends_on "openssl"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    inreplace "src/ruby_supportlib/phusion_passenger/platform_info/openssl.rb" do |s|
      s.gsub! "-I/usr/local/opt/openssl/include", "-I#{Formula["openssl"].opt_include}"
      s.gsub! "-L/usr/local/opt/openssl/lib", "-L#{Formula["openssl"].opt_lib}"
    end

    system "rake", "apache2" if build.with? "apache2-module"
    system "rake", "nginx"

    (libexec/"download_cache").mkpath

    # Fixes https://github.com/phusion/passenger/issues/1288
    rm_rf "buildout/libev"
    rm_rf "buildout/libuv"
    rm_rf "buildout/cache"

    necessary_files = %w[.editorconfig configure Rakefile README.md CONTRIBUTORS
                         CONTRIBUTING.md LICENSE CHANGELOG INSTALL.md
                         passenger.gemspec build bin doc man dev src resources
                         buildout]
    libexec.mkpath
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

    nginx_addon_dir = `/usr/bin/ruby ./bin/passenger-config about nginx-addon-dir`.strip
    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    mv libexec/"man", share
  end

  def caveats
    s = <<~EOS
      To activate Phusion Passenger for Nginx, run:
        brew install nginx --with-passenger

      EOS

    s += <<~EOS if build.with? "apache2-module"
      To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
        LoadModule passenger_module #{opt_libexec}/buildout/apache2/mod_passenger.so
        PassengerRoot #{opt_libexec}/src/ruby_supportlib/phusion_passenger/locations.ini
        PassengerDefaultRuby /usr/bin/ruby

      EOS
    s
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}/bin/passenger-config --ruby-libdir`.strip
    assert_equal "#{libexec}/src/ruby_supportlib", ruby_libdir
  end
end
