class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.1.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.1.0.tar.gz"
  sha256 "5d29f32517dadb6dbcd1255ea5bbc93a2b54b94fbf83653b4d65c7d6775b8634"
  license "libtiff"
  revision 1

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0f66c74d4ba96a1e9bac88a58a52335eaa0944de258e608ef62370e80fc5b24a" => :big_sur
    sha256 "f45e96a9c8bb58afdb284ef80e9936d816714fd86499230939ca94bb68e30c45" => :arm64_big_sur
    sha256 "d92eb164b8fbe723a6006023f883a77bc02d4e54d8bbb1db6855f1ad7f1f1d6e" => :catalina
    sha256 "6194841cb85000404c089288624f3897faa0c888f1653fb5c5388ba58cc8df8f" => :mojave
    sha256 "75d26fd0a430509b838c5b341221c9bb4a343dfa54dffd626c1f93313e4e512c" => :high_sierra
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --disable-webp
      --disable-zstd
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
