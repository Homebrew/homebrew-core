class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.20.1/node-v10.20.1.tar.xz"
  sha256 "ee1f88a04c608aeda1299bbcb0895eebb6394e901f03398c377236905d95f492"
  revision 2

  bottle do
    cellar :any
    sha256 "2d38510d712485965ac6bfc5189c6045fee477f894bde2fa8f67fe7cf4e681fc" => :catalina
    sha256 "f4e8b50e62af76611efaf430a0dbc9f8af53591520ac951e1e52d4671c57cd8c" => :mojave
    sha256 "fb1c20c3173c361d45755b028c5a22dd58bb9f9a1d7d78e62f817b0c75d16a28" => :high_sierra
  end

  keg_only :versioned_formula

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
