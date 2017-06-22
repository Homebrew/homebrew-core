class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.13.tar.gz"
  sha256 "5aaca0070992cc2e971e3bb2338ee749495613dcecab4c868fc547b4148f5311"
  revision 1

  bottle do
    cellar :any
    sha256 "e19f9e1b02a373ffa8ef57815e117466564cce65c2c9375734f2814235b692c4" => :sierra
    sha256 "3baac1e2249e2e5f3598da7c2e23eae663efac0391d73b8057de4abc49b91683" => :el_capitan
    sha256 "a1d8a3379bcccbe0243581037a4c98ad86f43c331e59c400eb1e273ce29f26e8" => :yosemite
  end

  depends_on "libpng" => :optional

  # These are all upstream already, remove on next release.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/j/jbig2dec/jbig2dec_0.13-4.1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/j/jbig2dec/jbig2dec_0.13-4.1.debian.tar.xz"
    sha256 "41114245b7410a03196c5f7def10efa78c9da12b4bac9d21d6fbe96ded4232dd"
    apply "patches/020160518~1369359.patch",
          "patches/020161212~e698d5c.patch",
          "patches/020161214~9d2c4f3.patch",
          "patches/020170426~5e57e48.patch",
          "patches/020170503~b184e78.patch",
          "patches/020170510~ed6c513.patch"
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
