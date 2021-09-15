class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/archive/0.10.1.tar.gz"
  sha256 "5bf0bbc555cb6059008f1b748370d4d2ee1e1fabd3eeab68475263556405ba39"
  license any_of: ["GPL-3.0", "MIT"]
  head "https://github.com/strophe/libstrophe.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "fe773ec4022f94be98b7bb05ba534bf87411b901a713416d8581ddc4968dd868"
    sha256 cellar: :any,                 big_sur:       "a215207d02f646e2299504f7166cf293fd9f9714181106e0f7707a4feef9303a"
    sha256 cellar: :any,                 catalina:      "cd0ced2cb8517143a02f68c2414de0c8f8da75829da7b46402cf645d6be960be"
    sha256 cellar: :any,                 mojave:        "17f49cd12a1fc672fe95155ac910265343cc877214af995e1728aa1ef75bc2f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33f8fece1588473b41591012bb0838faff237fa62ff8f19b26c25190c9959f96"
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
