class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.23.2/node-v10.23.2.tar.xz"
  sha256 "05a5e00e5e4342840f73ea40176416161ce9eeab6a4e936fc57bffd24dd1dbc7"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(10(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "681a8be7fd1bb8f44b6da4dbed4936900f23b7fe7c5dec79a46f5d93985cd55b"
    sha256 cellar: :any, catalina: "96f3e574446807638022256453d8e7ea992cccf718a07d293e520c91a603d067"
    sha256 cellar: :any, mojave:   "c7e39bc78e08037f55a4da8d17b21e9594a97308f7f19ff210bf6875d0e559c2"
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
