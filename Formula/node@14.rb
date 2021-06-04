class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.17.0/node-v14.17.0.tar.gz"
  sha256 "6114e82d3256136dc85a509d835442fbdf2f8430dcd8bfa7c304097344d06fb7"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9a94ee6cb701f73d99917367d534b9b100c08646d4c88461fec47b2a711e454e"
    sha256 cellar: :any, big_sur:       "062783bf3ef055f22c15a0828ebf944cfd493d5cbe4cdb2a3d7a6559fa7bdeb2"
    sha256 cellar: :any, catalina:      "dcb9cf2bceca1ed58609ef46a9a42b0f68bc3e408a365645b7bdb5bcf216e344"
    sha256 cellar: :any, mojave:        "c8b8d45d038f3fe40cd63fb7315ad101788b6b8470ba08fcb14b5ad52c237e04"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "icu4c"

  # Patch for compatibility with ICU 69
  # https://github.com/v8/v8/commit/035c305ce7761f51328b45f1bd83e26aef267c9d
  patch do
    url "https://github.com/v8/v8/commit/035c305ce7761f51328b45f1bd83e26aef267c9d.patch?full_index=1"
    sha256 "dfe0f6c312b0bea2733252db41fedae330afa21b055ee886b0b8f9ca780e2901"
    directory "deps/v8"
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
