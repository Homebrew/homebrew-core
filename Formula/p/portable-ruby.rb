require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableRuby < PortableFormula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.7.tar.gz"
  sha256 "23815a6d095696f7919090fdc3e2f9459b2c83d57224b2e446ce1f5f7333ef36"
  license "Ruby"

  # This regex restricts matching to versions other than X.Y.0.
  livecheck do
    formula "ruby"
    regex(/href=.*?ruby[._-]v?(\d+\.\d+\.(?:(?!0)\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6946ba2c387b47934e77c352c2056489421003ec7ddb2abf246cef2168ec140"
    sha256 cellar: :any_skip_relocation, catalina:      "b48c918b7693c6d27e8027dc803a18cf64ddce49552fb45d88f3cabb9eead0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39900ec84f8b944f3d8719a5fd2812b2b55533fca6a5996a23391cbf6ae10430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cca179476f84b0055766aa976005e3d45da635f0bc7616984675e2232db1eb4"
  end

  depends_on "pkgconf" => :build
  depends_on "portable-libyaml" => :build
  depends_on "portable-openssl" => :build

  on_linux do
    depends_on "portable-libffi" => :build
    depends_on "portable-libxcrypt" => :build
    depends_on "portable-zlib" => :build
  end

  resource "msgpack" do
    url "https://rubygems.org/downloads/msgpack-1.8.0.gem"
    sha256 "e64ce0212000d016809f5048b48eb3a65ffb169db22238fb4b72472fecb2d732"

    livecheck do
      url "https://rubygems.org/api/v1/versions/msgpack.json"
      strategy :json do |json|
        json.first["number"]
      end
    end
  end

  resource "bootsnap" do
    url "https://rubygems.org/downloads/bootsnap-1.18.6.gem"
    sha256 "0ae2393c1e911e38be0f24e9173e7be570c3650128251bf06240046f84a07d00"

    livecheck do
      url "https://rubygems.org/api/v1/versions/bootsnap.json"
      strategy :json do |json|
        json.first["number"]
      end
    end
  end

  # Fix compile on macOS 10.11
  patch do
    url "https://github.com/Bo98/ruby/commit/7aec5ca6e8ec13d92307615c32a511e02437d7de.patch?full_index=1"
    sha256 "644f706bbbb708c2e1d32de65138c335c3710e6d47f86624f9dd98806627e83f"
  end

  def install
    # Remove almost all bundled gems and replace with our own set.
    rm_r ".bundle"
    allowed_gems = ["debug"]
    bundled_gems = File.foreach("gems/bundled_gems").select do |line|
      line.blank? || line.start_with?("#") || allowed_gems.any? { |gem| line.match?(/\A#{Regexp.escape(gem)}\s/) }
    end
    rm_r(Dir["gems/*.gem"].reject do |gem_path|
      gem_basename = File.basename(gem_path)
      allowed_gems.any? { |gem| gem_basename.match?(/\A#{Regexp.escape(gem)}-\d/) }
    end)
    resources.each do |resource|
      resource.stage "gems"
      bundled_gems << "#{resource.name} #{resource.version}\n"
    end
    File.write("gems/bundled_gems", bundled_gems.join)

    libyaml = Formula["portable-libyaml"]
    libxcrypt = Formula["portable-libxcrypt"]
    openssl = Formula["portable-openssl"]
    libffi = Formula["portable-libffi"]
    zlib = Formula["portable-zlib"]

    args = portable_configure_args + %W[
      --prefix=#{prefix}
      --enable-load-relative
      --with-static-linked-ext
      --with-baseruby=#{RbConfig.ruby}
      --with-out-ext=win32,win32ole
      --without-gmp
      --disable-install-doc
      --disable-install-rdoc
      --disable-dependency-tracking
    ]

    # We don't specify OpenSSL as we want it to use the pkg-config, which `--with-openssl-dir` will disable
    args += %W[
      --with-libyaml-dir=#{libyaml.opt_prefix}
    ]

    if OS.linux?
      ENV["XCFLAGS"] = "-I#{libxcrypt.opt_include}"
      ENV["XLDFLAGS"] = "-L#{libxcrypt.opt_lib}"

      args += %W[
        --with-libffi-dir=#{libffi.opt_prefix}
        --with-zlib-dir=#{zlib.opt_prefix}
      ]

      # Ensure compatibility with older Ubuntu when built with Ubuntu 22.04
      args << "MKDIR_P=/bin/mkdir -p"

      # Don't make libruby link to zlib as it means all extensions will require it
      # It's also not used with the older glibc we use anyway
      args << "ac_cv_lib_z_uncompress=no"
    end

    # Append flags rather than override
    ENV["cflags"] = ENV.delete("CFLAGS")
    ENV["cppflags"] = ENV.delete("CPPFLAGS")
    ENV["cxxflags"] = ENV.delete("CXXFLAGS")

    system "./configure", *args
    system "make", "extract-gems"
    system "make"

    # Add a helper load path file so bundled gems can be easily used (used by brew's standalone/init.rb)
    system "make", "ruby.pc"
    arch = Utils.safe_popen_read("pkg-config", "--variable=arch", "./ruby-#{version.major_minor}.pc").chomp
    mkdir_p "lib/#{arch}"
    File.open("lib/#{arch}/portable_ruby_gems.rb", "w") do |file|
      (Dir["extensions/*/*/*", base: ".bundle"] + Dir["gems/*/lib", base: ".bundle"]).each do |require_path|
        file.write <<~RUBY
          $:.unshift "\#{RbConfig::CONFIG["rubylibprefix"]}/gems/\#{RbConfig::CONFIG["ruby_version"]}/#{require_path}"
        RUBY
      end
    end

    system "make", "install"

    abi_version = `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["ruby_version"]'`
    abi_arch = `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["arch"]'`

    if OS.linux?
      # Don't restrict to a specific GCC compiler binary we used (e.g. gcc-5).
      inreplace lib/"ruby/#{abi_version}/#{abi_arch}/rbconfig.rb" do |s|
        s.gsub! ENV.cxx, "c++"
        s.gsub! ENV.cc, "cc"
        # Change e.g. `CONFIG["AR"] = "gcc-ar-11"` to `CONFIG["AR"] = "ar"`
        s.gsub!(/(CONFIG\[".+"\] = )"gcc-(.*)-\d+"/, '\\1"\\2"')
        # C++ compiler might have been disabled because we break it with glibc@* builds
        s.sub!(/(CONFIG\["CXX"\] = )"false"/, '\\1"c++"')
      end

      # Ship libcrypt.a so that building native gems doesn't need system libcrypt installed.
      cp libxcrypt.lib/"libcrypt.a", lib/"libcrypt.a"
    end

    libexec.mkpath
    cp openssl.libexec/"etc/openssl/cert.pem", libexec/"cert.pem"
    openssl_rb = lib/"ruby/#{abi_version}/openssl.rb"
    inreplace openssl_rb, "require 'openssl.so'", <<~EOS.chomp
      ENV["PORTABLE_RUBY_SSL_CERT_FILE"] = ENV["SSL_CERT_FILE"] || File.expand_path("../../libexec/cert.pem", RbConfig.ruby)
      \\0
    EOS
  end

  test do
    cp_r Dir["#{prefix}/*"], testpath
    ENV["PATH"] = "/usr/bin:/bin"
    ruby = (testpath/"bin/ruby").realpath
    assert_equal version.to_s.split("-").first, shell_output("#{ruby} -e 'puts RUBY_VERSION'").chomp
    assert_equal ruby.to_s, shell_output("#{ruby} -e 'puts RbConfig.ruby'").chomp
    assert_equal "3632233996",
      shell_output("#{ruby} -rzlib -e 'puts Zlib.crc32(\"test\")'").chomp
    assert_equal " \t\n`><=;|&{(",
      shell_output("#{ruby} -rreadline -e 'puts Readline.basic_word_break_characters'").chomp
    assert_equal '{"a" => "b"}',
      shell_output("#{ruby} -ryaml -e 'puts YAML.load(\"a: b\")'").chomp
    assert_equal "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      shell_output("#{ruby} -ropenssl -e 'puts OpenSSL::Digest::SHA256.hexdigest(\"\")'").chomp
    assert_match "200",
      shell_output("#{ruby} -ropen-uri -e 'URI.open(\"https://google.com\") { |f| puts f.status.first }'").chomp
    system ruby, "-rrbconfig", "-e", <<~EOS
      Gem.discover_gems_on_require = false
      require "portable_ruby_gems"
      require "debug"
      require "fiddle"
      require "bootsnap"
    EOS
    system testpath/"bin/gem", "environment"
    system testpath/"bin/bundle", "init"
    # install gem with native components
    system testpath/"bin/gem", "install", "byebug"
    assert_match "byebug",
      shell_output("#{testpath}/bin/byebug --version")
  end
end
