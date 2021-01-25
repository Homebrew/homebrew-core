class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.2.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.2.0.tar.gz"
  sha256 "eb0484e568ead8fa23b513e9b0041df7e327f4ee2d22db5a533929dfc19633cb"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "31dc53e161b68394309dfe7743f9b7f37995b441d66b1637b9424696973b3d40" => :big_sur
    sha256 "50c09c0a4328c2625147ea78376523e11510ef26e4286953465e922e12d7e045" => :arm64_big_sur
    sha256 "208176ae2c5642eb0dff7c97d7b011d6b1d6317be4242db1e54bbb92609f758b" => :catalina
    sha256 "706a61c81bd7a17f266f315339ff63e9bc965c962cd6d9a6a03167cd620d07a1" => :mojave
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
