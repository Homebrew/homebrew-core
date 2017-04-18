class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.13.tar.gz"
  sha256 "5aaca0070992cc2e971e3bb2338ee749495613dcecab4c868fc547b4148f5311"

  bottle do
    cellar :any
    sha256 "8b0f528a21bc3fc6ef4a333a892d0bafee3650a40c2192102152ebab4702cd2b" => :sierra
    sha256 "9d486cf625f24d6b3d681451b041998ef70b86801c7cc0e75ffb074162267a08" => :el_capitan
    sha256 "5418d7ca54b8366f5f2135c130921f2426e67e872ace91ddb843689f7f61b9f7" => :yosemite
  end

  depends_on "libpng" => :optional

  # These are all upstream already, remove on next release.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/j/jbig2dec/jbig2dec_0.13-4.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/j/jbig2dec/jbig2dec_0.13-4.debian.tar.xz"
    sha256 "c4776c27e4633a7216e02ca6efcc19039ca757e8bd8fe0a7fbfdb07fa4c30d23"
    apply "patches/020160518~1369359.patch",
          "patches/020161212~e698d5c.patch",
          "patches/020161214~9d2c4f3.patch"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    args << "--without-libpng" if build.without? "libpng"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdint.h>
      #include <stdlib.h>
      #include <jbig2.h>

      int main()
      {
        Jbig2Ctx *ctx;
        Jbig2Image *image;
        ctx = jbig2_ctx_new(NULL, 0, NULL, NULL, NULL);
        image = jbig2_image_new(ctx, 10, 10);
        jbig2_image_release(ctx, image);
        jbig2_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-DJBIG_NO_MEMENTO", "-L#{lib}", "-ljbig2dec", "-o", "test"
    system "./test"
  end
end
