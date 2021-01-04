class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.23.1/node-v10.23.1.tar.xz"
  sha256 "88aa16f5af79615b183ca55ed81393763169e75d1fb96013cf1831895c6cedfa"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(10(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "b2780736458b36291d8a406447da9e14da2c58b7fd8f596e4fea6e26a1f96428" => :big_sur
    sha256 "a989ef58b07b8cac0b75bda295995406116ec2a775a5f1e8c88ff1c865f20c3b" => :catalina
    sha256 "b1154a6516e6041caf3847eb011ec157010d7ec5c4d15b739ac1264205611011" => :mojave
    sha256 "daba3ab331fb6b4033ff45f96e36d13424a150d779ae2820f55e4f4cff74340b" => :high_sierra
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
