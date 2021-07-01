class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.22.2/node-v12.22.2.tar.gz"
  sha256 "210a550c47056f29537e1b5b73cb78a88c44609c3b92aa003cf7862d3904ef99"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(12(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "07e3b8bcfb13fdeaffb78005217547d8e306e2b8eb2b7df1dca6ac426945d190"
    sha256 cellar: :any, big_sur:       "c45a5cf6332bf0d95801aa7d934ddc658eaaa4a904490183d5637ed03d440891"
    sha256 cellar: :any, catalina:      "b7abc525b8c061e6543e8631907f89ee56f62a517a8a08c3a33aa2aec1e2f0ce"
    sha256 cellar: :any, mojave:        "46331633475eda013a40673692e9a45e307eed0e6fbe0605dbdeb9843e680756"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "icu4c"

  # Patch for compatibility with ICU 69. Backported from
  # https://github.com/v8/v8/commit/035c305ce7761f51328b45f1bd83e26aef267c9d
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9eb96c36ff61c76c809c975f3b4463e826eae73c/node%4012/node%4012-icu69.patch"
    sha256 "c23163cc26c784479471f904fb47f1c16ec4177c687fd9c3988a8208a3faa583"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "python3", "configure.py", "--prefix=#{prefix}", "--with-intl=system-icu"
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
    system "#{bin}/npm", *npm_args, "install", "bufferutil"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
