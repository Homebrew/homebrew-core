class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://s3.amazonaws.com/phusion-passenger/releases/passenger-5.0.30.tar.gz"
  sha256 "f367e0c1d808d7356c3749222194a72ea03efe61a3bf1b682bd05d47f087b4e3"
  head "https://github.com/phusion/passenger.git"
  revision 2

  bottle do
    cellar :any
    sha256 "b5a0e3f52227526028f6a8c0f89e1222a25b49aed3d1d04db59533466d6b541e" => :sierra
    sha256 "ca5a5db79f0d9eac1639160d9e9201772e052b3e896203207a2e5c5e3461ae0d" => :el_capitan
    sha256 "ff5ae870c56361209a6022281ac35050f085056735f6a5d6deda95b4dafde121" => :yosemite
  end

  option "without-apache2-module", "Disable Apache2 module"

  depends_on :macos => :lion
  depends_on "pcre"
  depends_on "openssl"
  depends_on "apr-util"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    ENV["APU_CONFIG"] = Formula["apr-util"].opt_bin/"apu-1-config"
    ENV["APR_CONFIG"] = Formula["apr"].opt_bin/"apr-1-config"

    inreplace "src/ruby_supportlib/phusion_passenger.rb",
      "PREFERRED_NGINX_VERSION = '1.10.1'",
      "PREFERRED_NGINX_VERSION = '1.10.2'"
    inreplace "src/ruby_supportlib/phusion_passenger/platform_info/openssl.rb" do |s|
      s.gsub! "-I/usr/local/opt/openssl/include", "-I#{Formula["openssl"].opt_include}"
      s.gsub! "-L/usr/local/opt/openssl/lib", "-L#{Formula["openssl"].opt_lib}"
    end
    inreplace "src/ruby_supportlib/phusion_passenger/config/nginx_engine_compiler.rb",
      "http://nginx.org",
      "https://nginx.org"

    rake "apache2" if build.with? "apache2-module"
    rake "nginx"

    system("/usr/bin/ruby ./bin/passenger-config compile-nginx-engine")

    (libexec/"download_cache").mkpath

    # Fixes https://github.com/phusion/passenger/issues/1288
    rm_rf "buildout/libev"
    rm_rf "buildout/libuv"
    rm_rf "buildout/cache"

    necessary_files = Dir[".editorconfig", "configure", "Rakefile", "README.md", "CONTRIBUTORS",
      "CONTRIBUTING.md", "LICENSE", "CHANGELOG", "INSTALL.md",
      "passenger.gemspec", "build", "bin", "doc", "man", "dev", "src",
      "resources", "buildout"]
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

    nginx_addon_dir = `/usr/bin/ruby ./bin/passenger-config about nginx-addon-dir`.strip
    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    mv libexec/"man", share
  end

  def caveats
    s = <<-EOS.undent
      To activate Phusion Passenger for Nginx, run:
        brew install nginx --with-passenger

      EOS

    s += <<-EOS.undent if build.with? "apache2-module"
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
