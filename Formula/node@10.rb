class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.13.0/node-v10.13.0.tar.gz"
  sha256 "aa06825fff375ece7c0d881ae0de5d402a857e8cabff9b4a50f2f0b7b44906be"

  bottle do
    sha256 "72ea1acbc62c79d65d054b4f8b3154d216b4619e2e6607d478e6beac017a6359" => :mojave
    sha256 "e78df890254094099fa1f40977d0974b5bda8e8ac4aa2b6b2a4da95921e46a7d" => :high_sierra
    sha256 "267dc5ebf11ca667aadfb05058323f756ffc84911aa574bd39b58fb3644c4021" => :sierra
  end

  keg_only :versioned_formula

  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  deprecated_option "with-openssl" => "with-openssl@1.1"

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-npm" if build.without? "npm"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" << "--openssl-use-def-ca-store" if build.with? "openssl"

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    return if build.without? "npm"
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  def caveats
    if build.without? "npm"
      <<~EOS
        Homebrew has NOT installed npm. If you later install it, you should supplement
        your NODE_PATH with the npm module folder:
          #{HOMEBREW_PREFIX}/lib/node_modules
      EOS
    end
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output
    if build.with? "icu4c"
      output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
      assert_equal "1.234,56", output
    end

    if build.with? "npm"
      # make sure npm can find node
      ENV.prepend_path "PATH", opt_bin
      ENV.delete "NVM_NODEJS_ORG_MIRROR"
      assert_equal which("node"), opt_bin/"node"
      assert_predicate bin/"npm", :exist?, "npm must exist"
      assert_predicate bin/"npm", :executable?, "npm must be executable"
      npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
      system "#{bin}/npm", *npm_args, "install", "npm@latest"
      system "#{bin}/npm", *npm_args, "install", "bignum"
      assert_predicate bin/"npx", :exist?, "npx must exist"
      assert_predicate bin/"npx", :executable?, "npx must be executable"
      assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
    end
  end
end
