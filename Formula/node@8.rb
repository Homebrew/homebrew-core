class NodeAT8 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v8.12.0/node-v8.12.0.tar.xz"
  sha256 "5a9dff58016c18fb4bf902d963b124ff058a550ebcd9840c677757387bce419a"

  bottle do
    rebuild 1
    sha256 "46b430483d0541dd6b8d5f4bc834fcba14719c53233dfd59d9a9e24283c0f80e" => :mojave
    sha256 "2c13559186878d8562fe5acea407aa9f1a57dd33a5b147b3e3f0aac61661f2fd" => :high_sierra
    sha256 "60c20bd219f2dab1593a3624749b8f6fa1db25fb0a17c4a79e0b762f6f2407f0" => :sierra
    sha256 "e24f5ad36356819ce8728108440a3cd1e1b6938cc2beaa9a86516cf7fe8ea2d0" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "icu4c"

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc_4_2
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
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
