class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.22.7/node-v12.22.7.tar.xz"
  sha256 "cc6a23b44870679a94bd8f3c8d4e1f4b77bb2712a36888ab87463459e6785f6b"
  license "MIT"

  livecheck do
    url "https://nodejs.org/dist/"
    regex(%r{href=["']?v?(12(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "215d642ed997c347c3a3abc4b2913a8c813b46870b3822fe4084e1d1e4f91372"
    sha256 cellar: :any,                 big_sur:       "5d6a32315fd68e3a91d2ce30ef5e26e8cca73ab89893b7f965efcbfc1ae7af6e"
    sha256 cellar: :any,                 catalina:      "cee28342085656ad34b77e968aee90e2a8c02f527e2df820885e887de2ef08ee"
    sha256 cellar: :any,                 mojave:        "33b95dafb0722d184e56c06eedcb7d89f79c4261ce80139a0b2918f92b70f254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53027363c72756694fc56639cdf44d0427daac715e038d167b95bba9f562f38c"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "icu4c"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_macos do
    depends_on "macos-term-size"
  end

  # Fix build with brewed c-ares.
  # https://github.com/nodejs/node/pull/39739
  #
  # Remove when the following lands in a *c-ares* release:
  # https://github.com/c-ares/c-ares/commit/7712fcd17847998cf1ee3071284ec50c5b3c1978
  # https://github.com/c-ares/c-ares/pull/417
  patch :DATA

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = which("python3")

    args = %W[
      --prefix=#{prefix}
      --with-intl=system-icu
      --shared-libuv
      --shared-nghttp2
      --shared-openssl
      --shared-zlib
      --shared-brotli
      --shared-cares
      --shared-libuv-includes=#{Formula["libuv"].include}
      --shared-libuv-libpath=#{Formula["libuv"].lib}
      --shared-nghttp2-includes=#{Formula["libnghttp2"].include}
      --shared-nghttp2-libpath=#{Formula["libnghttp2"].lib}
      --shared-openssl-includes=#{Formula["openssl@1.1"].include}
      --shared-openssl-libpath=#{Formula["openssl@1.1"].lib}
      --shared-brotli-includes=#{Formula["brotli"].include}
      --shared-brotli-libpath=#{Formula["brotli"].lib}
      --shared-cares-includes=#{Formula["c-ares"].include}
      --shared-cares-libpath=#{Formula["c-ares"].lib}
      --openssl-use-def-ca-store
    ]
    system "python3", "configure.py", *args
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
    system "#{bin}/npm", *npm_args, "install", "ref-napi"
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end

__END__
--- a/src/cares_wrap.cc
+++ b/src/cares_wrap.cc
@@ -39,7 +39,7 @@
 # include <netdb.h>
 #endif  // __POSIX__
 
-# include <ares_nameser.h>
+# include <arpa/nameser.h>
 
 // OpenBSD does not define these
 #ifndef AI_ALL
