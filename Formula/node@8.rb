class NodeAT8 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v8.11.4/node-v8.11.4.tar.xz"
  sha256 "fbce7de6d96b0bcb0db0bf77f0e6ea999b6755e6930568aedaab06847552a609"

  bottle do
    sha256 "e2e5cb7bef2374d387a0bfc098b4f37d72fde5aca476c739695ceb2a8dc30f61" => :high_sierra
    sha256 "5936c758dcad44a07ab035897a62e04d43d0de5257847c60ef8805253308bfe7" => :sierra
    sha256 "2184abe84827b56361d269c734dc11c5e6eef942d9d5b29750b8603f2a9caf33" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-debug", "Build with debugger hooks"
  option "with-openssl", "Build against Homebrew's OpenSSL instead of the bundled OpenSSL"
  option "without-npm", "npm will not be installed"
  option "without-completion", "npm bash completion will not be installed"
  option "without-icu4c", "Build with small-icu (English only) instead of system-icu (all locales)"

  depends_on "python@2" => :build
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
    # icu4c 61.1 compatability
    ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"

    args = ["--prefix=#{prefix}"]
    args << "--without-npm" if build.without? "npm"
    args << "--debug" if build.with? "debug"
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
