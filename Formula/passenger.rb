class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://github.com/phusion/passenger/releases/download/release-5.3.6/passenger-5.3.6.tar.gz"
  sha256 "028b55d3943ad39247a164ad7f746fdc042cf5f52f1e89242f9d52c51aa24efa"
  head "https://github.com/phusion/passenger.git", :branch => "stable-5.3"

  bottle do
    sha256 "55d61d794bcbd769ef176ea07ad9992b532b0d50a20ff567e6e00e9b2f7bc580" => :mojave
    sha256 "9f8e1274e2136790bca4e0a8dbf554f39d7548495d461ddf70e5ba9dcd65ee00" => :high_sierra
    sha256 "bd3ad8ddff32f69e035bba9b7377c4f309816f808dd460c3b468e3fa0f490d33" => :sierra
  end

  option "without-apache2-module", "Disable Apache2 module"

  depends_on :macos => :lion
  depends_on "openssl"
  depends_on "pcre"

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

    necessary_files = %w[configure Rakefile README.md CONTRIBUTORS
                         CONTRIBUTING.md LICENSE CHANGELOG package.json
                         passenger.gemspec build bin doc images man dev src
                         resources buildout]
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
