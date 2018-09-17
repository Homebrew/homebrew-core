class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.9.2.tar.gz"
  sha256 "158145bc1565a5fd0bbd7f57e3e15d768e58b8a460897ab5918a5a689d67ae6f"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "2a3b013266d4e92e3587ce22d16ba46ad830e3f0dedade73f2c6b850203677d8" => :mojave
    sha256 "1e6c0b7461aeed6bf925a338248a577435d3b7f60561e09a7da9c530a05baaee" => :high_sierra
    sha256 "4ddabe86834d65dafb68a82b2f82c66b1052df5c0bd5cdd81318ae421c6ec0de" => :sierra
    sha256 "65162c4c6215dae7441c79aa50b31ef99c0ddfee55eea5f5d8974fb330a2dd96" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl"

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
