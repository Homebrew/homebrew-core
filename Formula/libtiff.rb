class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.1.0.tar.gz"
  sha256 "5d29f32517dadb6dbcd1255ea5bbc93a2b54b94fbf83653b4d65c7d6775b8634"

  bottle do
    cellar :any
    sha256 "449bd9123e73e4c4eab85b77322d769cc9df0f6adab05e9b9319b012d1215a68" => :catalina
    sha256 "dd060521aa30fb2f4678c9ebab6362104a9a705d098a90eac4059743c93c8c16" => :mojave
    sha256 "577c2754b00fc8a5009e08bfd7af630ab4812250508df20a1c92d3c7ae678b94" => :high_sierra
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
