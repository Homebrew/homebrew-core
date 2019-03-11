class NodeAT6 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v6.17.0/node-v6.17.0.tar.xz"
  sha256 "c1dac78ea71c2e622cea6f94ba97a4be49329a1d36cd05945a1baf1ae8652748"

  bottle do
    cellar :any_skip_relocation
    sha256 "38069ace5dafd7c3160334c417e8842a0c3695eb0efeb3e0bda3ed08915a9be5" => :mojave
    sha256 "776370159f4697c58e11fc77be7a3c845f6a3ac73c3fb449092a9884bd91cccd" => :high_sierra
    sha256 "3578994784d18fb1d7279f51d1cd82e96b198a1ac85a6157a3615a17b7951159" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  resource "icu4c" do
    url "https://ssl.icu-project.org/files/icu4c/58.2/icu4c-58_2-src.tgz"
    version "58.2"
    sha256 "2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c"
  end

  def install
    # Switches standard libary for native addons from libstdc++ to libc++ to
    # match the superenv enforced one for the node binary itself. This fixes
    # incompatibilities between native addons built with our node-gyp and our
    # node binary and makes building native addons with XCode 10.1+ possible.
    inreplace "common.gypi", "'MACOSX_DEPLOYMENT_TARGET': '10.7',",
                             "'MACOSX_DEPLOYMENT_TARGET': '#{MacOS.version}',"
    resource("icu4c").stage buildpath/"deps/icu"
    system "./configure", "--prefix=#{prefix}", "--with-intl=full-icu"
    system "make", "install"
  end

  def post_install
    # sets global prefix and prevents our patched common.gypi to be overriden
    # with the one downloaded by node-gyp with the header tarball otherwise
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\nnodedir = #{opt_prefix}\n")
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
  end
end
