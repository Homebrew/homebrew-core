class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.9.3.tar.gz"
  sha256 "8a3b79f62177ed59c01d4d4108357ff20bd933d53b845ee4e350d304c051a4fe"
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    cellar :any
    sha256 "da52155acc06ec67fb84cc51403bdecc76c6431a3d827ef3e30ea138b880b803" => :catalina
    sha256 "040195fb364d82bbc32e11bfd37e2dbabae64bc898602064c1a432b7c3869efd" => :mojave
    sha256 "149335c1a3224dbcfdb10bf4c5271edcc224c030d667fc9a8012244b4c2f06ed" => :high_sierra
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
