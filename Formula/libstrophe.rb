class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.12.2.tar.gz"
  sha256 "049232e3968ad65c65e08601cb3de171d3a25d154b6f14332c35a7bf961e2c9d"
  license all_of: ["GPL-3.0-only", "MIT"]
  head "https://github.com/strophe/libstrophe.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f9ae71b8f0ae88f3de87811b61d325ba1a986c1ceaceaf891fd47e3c71f1c164"
    sha256 cellar: :any,                 arm64_monterey: "da9690a4006d8011fffc155eda0e6860f2c76296b24ffcebf99bda9005d901f7"
    sha256 cellar: :any,                 arm64_big_sur:  "7898879a8407daf35cebacaee1f9bd9a282596bdf5497f49dc25f8211d9afa66"
    sha256 cellar: :any,                 ventura:        "471537873386ed1e4a6df9f37eb6040d6ab7a113f4aa27a11580058d099ec9bc"
    sha256 cellar: :any,                 monterey:       "4be10d525522a176fdc10d37c4206eef981ecd326c4717ac43e929a0ecdbe99c"
    sha256 cellar: :any,                 big_sur:        "7da045515977c9457f38384687bc1e3a0b271b228aa8f5f5dc737dc42aea46fa"
    sha256 cellar: :any,                 catalina:       "a6bb42211705f771de89f0f89d007eeaabb7aa61bd41650b5e40f6add8f43027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2bc04a0aa1e2189519bd9d9b6840dc2c22176106984f60d1a0dfae5cfe4160d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "expat"
  uses_from_macos "libxml2"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <strophe.h>
      #include <assert.h>

      int main(void) {
        xmpp_ctx_t *ctx;
        xmpp_log_t *log;

        xmpp_initialize();
        log = xmpp_get_default_logger(XMPP_LEVEL_DEBUG);
        assert(log);

        ctx = xmpp_ctx_new(NULL, log);
        assert(ctx);

        xmpp_ctx_free(ctx);
        xmpp_shutdown();
        return 0;
      }
    EOS
    flags = ["-I#{include}/", "-L#{lib}", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
