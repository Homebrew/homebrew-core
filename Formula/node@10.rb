class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.23.1/node-v10.23.1.tar.xz"
  sha256 "88aa16f5af79615b183ca55ed81393763169e75d1fb96013cf1831895c6cedfa"
  license "MIT"
  revision 1

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(10(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "9b559405ec7fd06d27ccf42e32d701584f5b9bbc82daa0b326dd3b8106a1be0e" => :big_sur
    sha256 "4cdacb85745a621f6c9a5c68a3f85cd2120948ce7422b5040e35a7cb1ddc64a1" => :catalina
    sha256 "da429b4bd778eae04b4bdbe1a9cca7bb53183bef25d4c4ffa63840646fcaf008" => :mojave
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
