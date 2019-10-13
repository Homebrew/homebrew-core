class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.9.3.tar.gz"
  sha256 "8a3b79f62177ed59c01d4d4108357ff20bd933d53b845ee4e350d304c051a4fe"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "79de5afffdfb6e941771ba1dc935cac83522f33014d265924a59de2b156c4cd0" => :catalina
    sha256 "db80dcadb0ae3ffa08bae140ecc0916a1f5fbb00ce0bebbbf1e43e6326e4b7dd" => :mojave
    sha256 "6fc32e35e060c9ef7031360f92d316ba2bfea773ca070a12773daa2d9f248046" => :high_sierra
    sha256 "0c915d04b877af792ee95c7a1cf6bb35f5cc15c58878db3ef392176d98328708" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@1.1"

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
