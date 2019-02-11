class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.15.1/node-v10.15.1.tar.gz"
  sha256 "5202f6f6bfda16554c8121ea78e4cffee52e2707e1136c88f3c40b0c2af8100f"

  bottle do
    cellar :any
    sha256 "5a411a2295f6040438ad96a572bcaeb587b168bd5b5414b298965293ec73be34" => :mojave
    sha256 "b80b682c346c4bb9b398ed4a085d6d8ec5eac0755ba2a6714b6df448e46a0277" => :high_sierra
    sha256 "555b29c365df7c2903e5f98d1802826194bfa48b0607299a3d70cb657578cb50" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "icu4c"

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
