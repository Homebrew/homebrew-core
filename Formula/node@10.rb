class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.15.2/node-v10.15.2.tar.gz"
  sha256 "3b81ea6b0ae1c887ed4215d6a0b9349284c811bd98c8ddd7a0370f6cc9eb8182"
  revision 1

  bottle do
    cellar :any
    sha256 "4e84910817696d3a02811cc9b796f5406eff5de4d764976eff9d7657fea0217d" => :mojave
    sha256 "d5e66d33f38d042480db4e7de490883e9bd5f438a103641704f709fdf0b9f191" => :high_sierra
    sha256 "95775fb9bb5107886ebb0dce6d3a224f78e919874d215cd4b528ebaa3c42f723" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "icu4c"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-intl=system-icu"
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

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
