class Libstrophe < Formula
  desc "XMPP library for C"
  homepage "https://strophe.im/libstrophe/"
  url "https://github.com/strophe/libstrophe/releases/download/0.14.0/libstrophe-0.14.0.tar.gz"
  sha256 "d079668474d5c3aa4555347c33e77014a1071629603557cc506a6bc6f82e01f5"
  license all_of: ["GPL-3.0-only", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9d7e8c18a0b80ac3779819038ed50480ed8f2659730cdaeef0adb2201a8fda70"
    sha256 cellar: :any, arm64_tahoe:       "ef631131d639fb46c768687982c6f0a01469e9fd0f6e684352a25a39e1142ab4"
    sha256 cellar: :any, arm64_sequoia:     "fa404216bb1400211b77a36f83b7da42aae0a55912265bea6acb8079bfb47355"
    sha256 cellar: :any, arm64_linux:       "9d4d1c11a69109fa009f68deb99fcbd91147ca2522dcfd097ff25c0e15b34b06"
    sha256 cellar: :any, x86_64_linux:      "ea0283e684daf2c5abdc3a4f7b760476036efce0ed17d1eb06f7f0b8e7a34e2e"
  end

  head do
    url "https://github.com/strophe/libstrophe.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "expat"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    flags = ["-I#{include}/", "-L#{lib}", "-lstrophe"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
