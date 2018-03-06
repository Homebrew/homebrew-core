class NodeAT8 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v8.9.4/node-v8.9.4.tar.xz"
  sha256 "6cdcde9c9c1ca9f450a0b24eafa229ca759e576daa0fae892ce74d541ecdc86f"
  revision 1
  head "https://github.com/nodejs/node.git", :branch => "v8.x-staging"

  bottle do
    sha256 "761bf8e243c2b4745d988ebe2d727261f878c3f514cc3ae65068a5f30914c4d4" => :high_sierra
    sha256 "58951832753bfad93fb58776098654c780b0f0dc35ac4ab61df5e6d637a58590" => :sierra
    sha256 "f230c0637ee65d386a6229e8578a1e61f19386dc1affc5edc74fb4bceeee94a9" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-debug", "Build with debugger hooks"
  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  depends_on "python@2" => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "openssl" => :optional

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--without-npm" if build.without? "npm"
    args << "--debug" if build.with? "debug"
    args << "--with-intl=system-icu" if build.with? "icu4c"
    args << "--shared-openssl" if build.with? "openssl"
    args << "--tag=head" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    return if build.without? "npm"

    (lib/"node_modules/npm/npmrc").atomic_write <<~EOS
      prefix = #{HOMEBREW_PREFIX}
      python = /usr/bin/python
    EOS
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
      system "#{bin}/npm", *npm_args, "install", "bignum" unless head?
      assert_predicate bin/"npx", :exist?, "npx must exist"
      assert_predicate bin/"npx", :executable?, "npx must be executable"
      assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
    end
  end
end
