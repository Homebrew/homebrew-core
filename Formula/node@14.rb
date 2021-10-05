class NodeAT14 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v14.18.0/node-v14.18.0.tar.gz"
  sha256 "2272312d7eb48a28e982af395142d916385b0572380d07c89f9abd9c97810189"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(14(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "35ef1403101a2ff361051d7617fc6c1a3b8dd905e37cb7b77b2b5bb7de5c4ee4"
    sha256 cellar: :any,                 big_sur:       "a4d534988d6b9d80cb5420982ab7a7bf757a8b860171bca0ac3529f8b5a43bfc"
    sha256 cellar: :any,                 catalina:      "a4926228d9e56b669edfa56a6bb69fc8c1f8a84fc3bf93e29b577a1d159d1a63"
    sha256 cellar: :any,                 mojave:        "12255e38d951ce3933c898b4921ab24206b524055cc3f837a3acfbe748fb7be2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c7a12b8e7a59e37f57c1c22d9bab4df86680dad7f67fb7e52f587f1dd3f517"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "icu4c"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "python3", "configure.py", "--prefix=#{prefix}", "--with-intl=system-icu"
    system "make", "install"

    term_size_vendor_dir = lib/"node_modules/npm/node_modules/term-size/vendor"
    term_size_vendor_dir.rmtree # remove pre-built binaries

    if OS.mac?
      macos_dir = term_size_vendor_dir/"macos"
      macos_dir.mkpath
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(macos_dir), macos_dir
    end
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
    # FIXME: See https://github.com/Homebrew/homebrew-core/pull/86090
    # system "#{bin}/npm", *npm_args, "install", "bufferutil"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
