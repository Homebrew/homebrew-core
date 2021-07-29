class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.22.4/node-v12.22.4.tar.gz"
  sha256 "613b5a895d85d72b4aa495bdf0ffa483ad8b33635a173c4beb94d2842db740f5"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(12(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c5e43bbfb4ed9b5866bd0f5aefb5cb40f06504138ec57bd92a595eec01ac823b"
    sha256 cellar: :any,                 big_sur:       "09dce109119522b874a50633fce1b9e03c3a4f6d8e8fc17b56bc6aaabace8214"
    sha256 cellar: :any,                 catalina:      "2a7c221af40ac971028770eaf5b005b0a1135b9c206da77aa57b1805b2632d30"
    sha256 cellar: :any,                 mojave:        "1eefa8281d0ed8b35492b1fb57a6f579341de05325766c6f0587f282455473df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e83be53c90a0e2b72d6f97509fe19c6dc008c1f39ce54f3bf2be8806e2f05d9d"
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
