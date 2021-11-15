class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.24.1/node-v10.24.1.tar.xz"
  sha256 "d72fc2c244603b4668da94081dc4d6067d467fdfa026e06a274012f16600480c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, monterey: "5714defcf3505e22bc5af68f26872b34b45c955db2d4a1701b080378c6b56166"
    sha256 cellar: :any, big_sur:  "84095e53ee88c7acc39a574a64e7832bbb7326be76a4de502ed55fdd47e784c4"
    sha256 cellar: :any, catalina: "be200f225fd88d1a4a1efba2470b305accbddff927bf7d5287eeb4777fb02b9c"
    sha256 cellar: :any, mojave:   "cdaf548a304fb2eda428a61c8b25c406e2ada5f9eb7cf5b56174d0753f153598"
  end

  keg_only :versioned_formula

  deprecate! date: "2021-04-30", because: :unsupported

  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on :macos # Due to Python 2 (Will not work with Python 3 without extensive patching)
  # Node 10 will be EOL April 2021

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
