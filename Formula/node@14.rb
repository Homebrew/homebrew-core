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
    sha256 cellar: :any, arm64_big_sur: "9c6d7979a4ce9fb2748db735323981da246b33fb3729ebe9621a5245fa86d19e"
    sha256 cellar: :any, big_sur:       "98b809f5232ce62937f1e6a341db724f4cf8589e4742bd93c96b4332f4b30c2a"
    sha256 cellar: :any, catalina:      "0aa9ab6ebed657fd5f054e39cf21df1a22dd0cccaa80396d4833226b66144fa8"
    sha256 cellar: :any, mojave:        "a7f082b05947ce80e6294d234e1911806c769eb8843f939bd05d2dd4c70a2220"
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
