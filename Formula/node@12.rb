class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.16.1/node-v12.16.1.tar.gz"
  sha256 "4fe8c3454f9bee5bbe72d44aa25cd931859b3037b7a9473081b3b2bd1b465b95"

  bottle do
    cellar :any
    sha256 "afad657312117b64406caa7fda445aaa2a6d42f6c67aa7cf434f3b239ccb70b8" => :catalina
    sha256 "3dee3426e2ea8928d0724a801591ad3ad465a5b581b90981e773bb83cd0bda95" => :mojave
    sha256 "43abdcbfc002ca7764eb4982d7b939ec94a18a8d9cbfa4a5253a5219a47629a3" => :high_sierra
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
