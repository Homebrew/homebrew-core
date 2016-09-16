class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "http://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.9.1.tar.gz"
  sha256 "c90493f986e5bd407132c5a3e174378c02cb80fa4eaee29875e06b4bba6afcc3"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "3b2dc1fd615c7702ca0fc35c0985d5718ebd9a406d51cbd413faf5d253d91c9c" => :el_capitan
    sha256 "8cfb1bd728ada80d245b2380e406984df2889802f262513048e0de3600a0bdd6" => :yosemite
    sha256 "052b9756034f0975b9662458e9180d76a47cd28cf5db11eb38368137243b2b2d" => :mavericks
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
