class NodeAT10 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v10.16.3/node-v10.16.3.tar.gz"
  sha256 "db5a5e03a815b84a1266a4b48bb6a6d887175705f84fd2472f0d28e5e305a1f8"

  bottle do
    cellar :any
    sha256 "39b1a9fd71a615d690203b57588be046e838250af15cbe00d1f8a5e9dd60f02b" => :mojave
    sha256 "4716d08e4a8f6b1b52555563a11cb190b6f9e273dd5834f73ea9022eb219ca4d" => :high_sierra
    sha256 "0b7d09d24666d72a2985eb92e2ab3e997946928399bed368ccdbd0a12a9551df" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build # does not support Python 3
  depends_on "icu4c"

  # Fixes detecting Apple clang 11.
  patch do
    url "https://github.com/nodejs/node/commit/1f143b8625c2985b4317a40f279232f562417077.patch?full_index=1"
    sha256 "12d8af6647e9a5d81f68f610ad0ed17075bf14718f4d484788baac37a0d3f842"
  end

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
