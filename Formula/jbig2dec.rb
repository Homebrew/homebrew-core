class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://ghostscript.com/jbig2dec.html"
  url "http://downloads.ghostscript.com/public/jbig2dec/jbig2dec-0.14.tar.gz"
  sha256 "21b498c3ba566f283d02946f7e78e12abbad89f12fe4958974e50882c185014c"

  bottle do
    cellar :any
    sha256 "daa85d162a799f452fd221341ea065813c8dc698947b1858365f50f97d74b974" => :high_sierra
    sha256 "e19f9e1b02a373ffa8ef57815e117466564cce65c2c9375734f2814235b692c4" => :sierra
    sha256 "3baac1e2249e2e5f3598da7c2e23eae663efac0391d73b8057de4abc49b91683" => :el_capitan
    sha256 "a1d8a3379bcccbe0243581037a4c98ad86f43c331e59c400eb1e273ce29f26e8" => :yosemite
  end

  depends_on "libpng" => :optional

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
