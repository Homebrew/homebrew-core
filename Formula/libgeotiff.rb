class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.2.tar.gz"
  sha256 "ad87048adb91167b07f34974a8e53e4ec356494c29f1748de95252e8f81a5e6e"

  bottle do
    sha256 "194dc211dc45fe89183b53245ed494f4338afedaf65635202ae61df4495139aa" => :sierra
    sha256 "2256a133251e48d5df3719d1e83e9b2ac2e8be7bea41fcff25d036dce1e3cef7" => :el_capitan
    sha256 "0e283a6d16503c98c978092d98573f68a8d4e59aefe0b86f7ba6e6e3f33597c8" => :yosemite
  end

  head do
    url "https://svn.osgeo.org/metacrs/geotiff/trunk/libgeotiff"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "libtiff"
  depends_on "lzlib"
  depends_on "jpeg"
  depends_on "proj"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # Separate steps or install fails
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "geotiffio.h"
      #include "xtiffio.h"
      #include <stdlib.h>
      #include <string.h>

      int main(int argc, char* argv[])
      {
        TIFF *tif = XTIFFOpen(argv[1], "w");
        GTIF *gtif = GTIFNew(tif);
        TIFFSetField(tif, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        GTIFKeySet(gtif, GeogInvFlatteningGeoKey, TYPE_DOUBLE, 1, (double)123.456);

        int i;
        char buffer[20L];

        memset(buffer,0,(size_t)20L);
        for (i=0;i<20L;i++){
          TIFFWriteScanline(tif, buffer, i, 0);
        }

        GTIFWriteKeys(gtif);
        GTIFFree(gtif);
        XTIFFClose(tif);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltiff", "-lgeotiff", "-o", "test"
    system "./test", "test.tif"
    assert_match /GeogInvFlatteningGeoKey.*123.456/, shell_output("#{bin}/listgeo test.tif")
  end
end
