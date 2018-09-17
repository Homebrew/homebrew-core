class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs922/jbig2dec-0.14.tar.gz"
  sha256 "21b498c3ba566f283d02946f7e78e12abbad89f12fe4958974e50882c185014c"

  bottle do
    cellar :any
    sha256 "85fc216faf078a49753c6cd65fd1bd2ce84d137f79e40af83de29d03e7794bd1" => :mojave
    sha256 "197656bee979449ea283d855f0332afa414a31f7114123f477f3f9f2cc192763" => :high_sierra
    sha256 "a98bac77f5b916d67c1c7742ee3462af053c2ff0726dacaf5b0bcb2e9aef7e74" => :sierra
    sha256 "beb6ea36ce8edffa4ff8569231413fab5f3de7338379b35b49d208e16243577d" => :el_capitan
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
    (testpath/"test.c").write <<~EOS
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
