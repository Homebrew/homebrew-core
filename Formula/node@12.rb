class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.16.0/node-v12.16.0.tar.gz"
  sha256 "ae2dfe74485d821d4fef7cf1802acd2322cd994c853a2327c4306952f4453441"

  bottle do
    cellar :any
    sha256 "f93bd94f306d3d3ba5a5a6d0891fcd081d357d29c2e8472412884c6a65083862" => :catalina
    sha256 "4dc75cb0a8bc39c7ae9f5f7f67a7de3ed58ae71038420b62eaf53d52ca820771" => :mojave
    sha256 "6448f3281dcc991c296899b084fe15cbe2d4f102edef8b2096fe4ac2a53f9a87" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "icu4c"

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

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
