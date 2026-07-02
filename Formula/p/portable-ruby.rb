require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableRuby < PortableFormula
  desc "Powerful, clean, object-oriented scripting language"
  homepage "https://www.ruby-lang.org/"
  url "https://cache.ruby-lang.org/pub/ruby/4.0/ruby-4.0.5.tar.gz"
  sha256 "7d6149079a63f8ae1d326c9fa65c6019ba2dc3155eae7b39159817911c88958e"
  license "Ruby"
  revision 1

  # This regex restricts matching to versions other than X.Y.0.
  livecheck do
    formula "ruby"
    regex(/href=.*?ruby[._-]v?(\d+\.\d+\.(?:(?!0)\d+)(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ba8d535df01e4bf97e6661c3815796fd77364ea2552606e891659133a76f0e1"
    sha256 cellar: :any_skip_relocation, catalina:      "a731026301924336a5ee2051689788cd91ab09c2d42cb7b51c280e8fdcd85c7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca348cde9326562ed43c90f58886ee15c0a4e2c0dfd489686f56f059f9e77ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2627985aa990199b93efb66d8e6752e8234c4901fa3a365fa13875ba45a4059e"
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
    url "https://rubygems.org/downloads/bootsnap-1.24.5.gem"
    sha256 "36b677448524d279b470469aabd5dff4a980e3fa4931a0df68da4a500eb1b6c4"

    livecheck do
      url "https://rubygems.org/api/v1/versions/bootsnap.json"
      strategy :json do |json|
        json.first["number"]
      end
    end
  end

  def install
    # Remove almost all bundled gems and replace with our own set.
    rm_r ".bundle"
    # Allowed gem dependency tree:
    # - debug
    # - fiddle
    # - irb
    #   - reline
    #   - rdoc
    # - rake
    allowed_gems = %w[debug fiddle irb rake reline rdoc]
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

    # Cross-compiled builds on macOS need BUILTIN_BINARY=yes to ensure
    # builtins are properly generated. Without this, gem_prelude and
    # RbConfig don't work correctly. This works because our cross-compile
    # is "safe" - the binary still runs on the build machine.
    # miniruby needs to be force enabled for this to work.
    make_args = []
    if OS.mac? && CROSS_COMPILING
      ENV["MINIRUBY"] = "./miniruby -I$(srcdir)/lib -I. -I$(EXTOUT)/common"
      make_args << "BUILTIN_BINARY=yes"
      make_args << "PREP=miniruby"
      make_args << "RUNRUBY_COMMAND=$(MINIRUBY) $(tooldir)/runruby.rb --extout=$(EXTOUT) $(RUNRUBYOPT)"
    end

    system "./configure", *args
    system "make", "extract-gems"
    system "make", *make_args

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

    system "make", "install", *make_args

    abi_version = `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["ruby_version"]'`
    abi_arch = `#{bin}/ruby -rrbconfig -e 'print RbConfig::CONFIG["arch"]'`

    if OS.linux?
      inreplace lib/"ruby/#{abi_version}/#{abi_arch}/rbconfig.rb" do |s|
        # C++ compiler might have been disabled because we break it with glibc@* builds
        s.sub!(/(CONFIG\["CXX"\] = )"false"/, '\\1"c++"')
      end

      # Ship libcrypt.a so that building native gems doesn't need system libcrypt installed.
      cp libxcrypt.lib/"libcrypt.a", lib/"libcrypt.a"
    end

    libexec.mkpath
    cp openssl.libexec/"etc/openssl/cert.pem", libexec/"cert.pem"
    openssl_rb = lib/"ruby/#{abi_version}/openssl.rb"
    inreplace openssl_rb, "require 'openssl.so'", <<~RUBY.chomp
      ENV["PORTABLE_RUBY_SSL_CERT_FILE"] = ENV["SSL_CERT_FILE"] || File.expand_path("../../libexec/cert.pem", RbConfig.ruby)
      \\0
    RUBY
  end

  test do
    cp_r Dir["#{prefix}/*"], testpath
    ENV["PATH"] = "/usr/bin:/bin"
    ruby = (testpath/"bin/ruby").realpath
    assert_equal version.to_s.split("-").first, shell_output("#{ruby} -e 'puts RUBY_VERSION'").chomp
    assert_equal ruby.to_s, shell_output("#{ruby} -e 'puts RbConfig.ruby'").chomp
    assert_equal "3632233996",
      shell_output("#{ruby} -rzlib -e 'puts Zlib.crc32(\"test\")'").chomp
    assert_equal '{"a" => "b"}',
      shell_output("#{ruby} -ryaml -e 'puts YAML.load(\"a: b\")'").chomp
    assert_equal "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      shell_output("#{ruby} -ropenssl -e 'puts OpenSSL::Digest::SHA256.hexdigest(\"\")'").chomp
    assert_match "200",
      shell_output("#{ruby} -ropen-uri -e 'URI.open(\"https://google.com\") { |f| puts f.status.first }'").chomp
    system ruby, "-rrbconfig", "-e", <<~RUBY
      Gem.discover_gems_on_require = false
      require "portable_ruby_gems"
      require "debug"
      require "fiddle"
      require "bootsnap"
    RUBY
    system testpath/"bin/rake", "--version"
    system testpath/"bin/irb", "--version"
    system testpath/"bin/gem", "environment"
    system testpath/"bin/bundle", "init"
    # install gem with native components
    system testpath/"bin/gem", "install", "oj"
    assert_match "Oj",
      shell_output("#{ruby} -roj -e 'puts Oj.name'")
  end
end
