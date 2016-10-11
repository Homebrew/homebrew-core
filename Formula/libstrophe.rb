class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.9.1.tar.gz"
  sha256 "c90493f986e5bd407132c5a3e174378c02cb80fa4eaee29875e06b4bba6afcc3"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "f0de1f0155ec4b9d7c936d0c3a0c0ecae7ccf0d1306baa4df47d58d6116e75fe" => :sierra
    sha256 "da3d292e0c9d6e642038fffb8f79b4ec7eeced72900135b7cfc7cb4dfead5dc0" => :el_capitan
    sha256 "7ae2803a6ad206a7642b822a9ad8078beeb5bd1108bd3ef1cf46cc72094c6653" => :yosemite
    sha256 "6a6a3d52acff666a214cfdfb5e7559b3c32903d61c12405018ba25043d9e3416" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "openssl"
  depends_on "check"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    flags = ["-I#{include}/", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
