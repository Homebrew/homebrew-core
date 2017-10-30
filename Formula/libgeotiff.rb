class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.2.tar.gz"
  sha256 "ad87048adb91167b07f34974a8e53e4ec356494c29f1748de95252e8f81a5e6e"
  revision 1

  bottle do
    sha256 "47f9a4c29186e4e4b17ea1598b22c85fff045a06c64cbe44a878966f32f5489c" => :high_sierra
    sha256 "3e497773ae48cb38f7d7bdbaa19f137d23d87b5b1980d3feea2c818680acd145" => :sierra
    sha256 "97b06d1759717ccfed9b2e21de20d256b8852d472ed2aaa7ce7ec16f260fbe1a" => :el_capitan
    sha256 "90b680bcf7a45cd17ca3066713bea7c0162811ff5a20804a8afa282bf1c87638" => :yosemite
  end

  head do
    url "https://svn.osgeo.org/metacrs/geotiff/trunk/libgeotiff"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "proj"

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-jpeg"
    system "make" # Separate steps or install fails
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
