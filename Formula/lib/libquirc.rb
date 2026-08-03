class Libquirc < Formula
  desc "QR decoder library"
  homepage "https://github.com/dlbeer/quirc"
  url "https://github.com/dlbeer/quirc/archive/refs/tags/v1.2.tar.gz"
  sha256 "73c12ea33d337ec38fb81218c7674f57dba7ec0570bddd5c7f7a977c0deb64c5"
  license "ISC"
  head "https://github.com/dlbeer/quirc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "sdl12-compat"
  depends_on "sdl_gfx"

  def install
    inreplace "Makefile", "libquirc.so.$(LIB_VERSION)", "libquirc.so"
    system "make", "all", "inspect"
    system "make", "quirc-demo", "quirc-scanner" if OS.linux?

    # Few issues stop us from using `make install`. First, demos are compile through `install` which require Linux.
    # Second, the installer hardcodes install with root. Finally, it (accidentally) installs to files instead of
    # folders.
    if OS.linux?
      bin.install "quirc-demo"
      bin.install "quirc-scanner"
    end
    bin.install "inspect" => "qr-inspect" # Original name is quite generic, so rename to avoid conflicts.
    bin.install "qrtest"
    lib.install "libquirc.a"
    lib.install "libquirc.so"
    include.install "lib/quirc.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <quirc.h>
      int main() {
        struct quirc *qr;

        qr = quirc_new();
        if (!qr) return 1;

        quirc_destroy(qr);
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lquirc", "-o", "test"
    system "./test"
  end
end
