class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.16.1/node-v14.16.1.tar.gz"
  sha256 "5f5080427abddde7f22fd2ba77cd2b8a1f86253277a1eec54bc98a202728ce80"
  license "MIT"
  revision 1

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e543475b5c4b37c8e5dc1aafe8df8c0640222ae052a7c764e0e1bae44401255a"
    sha256 cellar: :any, big_sur:       "0c664e4823ba39c47b7515cfed6ea6b5777a9c4b024c2620980a51c46d850159"
    sha256 cellar: :any, catalina:      "ff678a2d176d9c8e09a3b92b08ca80dceca867cf038b87ce2934e140103321fa"
    sha256 cellar: :any, mojave:        "b29860c0ae030827361c237c8626ea78562931145b5a62df8aebc1dba3d94acd"
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
