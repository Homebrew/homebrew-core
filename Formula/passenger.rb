class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://s3.amazonaws.com/phusion-passenger/releases/passenger-5.0.30.tar.gz"
  sha256 "f367e0c1d808d7356c3749222194a72ea03efe61a3bf1b682bd05d47f087b4e3"
  head "https://github.com/phusion/passenger.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b8378337f02b1999c0b5c3405c38ae70955c231f40451ae6e7a8f59f8e61a8c6" => :sierra
    sha256 "58a9719049a21cc39d108a8ca8d2628203df0a372912249ddf021d85d66fff54" => :el_capitan
    sha256 "c91893004fd2d0312db156a45409b02bf0cfe92a495cb6d3ac4902025108e077" => :yosemite
  end

  option "without-apache2-module", "Disable Apache2 module"

  depends_on "pcre"
  depends_on "openssl"
  depends_on :macos => :lion

  # macOS Sierra ships the APR libraries & headers, but has removed the
  # apr-1-config & apu-1-config executables which are used to find
  # those elements. We may need to adopt a broader solution if this problem
  # expands, but currently subversion & passenger are the only breakage as a result.
  if MacOS.version >= :sierra
    depends_on "apr-util" => :build
    depends_on "apr" => :build
  end

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    if MacOS.version >= :sierra
      ENV["APU_CONFIG"] = Formula["apr-util"].opt_bin/"apu-1-config"
      ENV["APR_CONFIG"] = Formula["apr"].opt_bin/"apr-1-config"
    end

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
