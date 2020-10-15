class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.10.0.tar.gz"
  sha256 "8d804e4c74cea1133203cc95a59a88f700fbdaead076e7959b495d734dd7936d"
  license any_of: ["GPL-3.0", "MIT"]
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "a9d230d388d880b06d5e17d14e0943499d7b2eaccb33cd7921e63f16891f1d3b" => :catalina
    sha256 "e29fab2eb0fda7024475d2ecd57476b33eee51c4123041b9e447b0a1f462fc34" => :mojave
    sha256 "a1739c44c90b762a2e94e7e97a48ba5d3e6c99bfd1d1fe3aacb4f0aee571a919" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
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
