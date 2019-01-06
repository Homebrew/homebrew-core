class NodeAT6 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v6.16.0/node-v6.16.0.tar.xz"
  sha256 "0d0882a9da1ccc217518d3d1a60dd238da9f52bed0c7daac42b8dc3d83bd7546"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb84229c998be50def2edd24704db1c50b89531df9ffd4089afc3ce79618ac3f" => :mojave
    sha256 "15f2347562850d6c8cbe6bdc5045df18f05c4564d4643bcdb1975adaf3ccb195" => :high_sierra
    sha256 "592951f64ef960db27cac1fefc609098a66ce0c587f9c56adc7efb0f2ce538ef" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@2" => :build

  # Per upstream - "Need g++ 4.8 or clang++ 3.4".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_2
  ("4.3".."4.7").each do |n|
    fails_with :gcc => n
  end

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
