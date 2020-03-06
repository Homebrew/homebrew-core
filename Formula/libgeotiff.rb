class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "https://github.com/OSGeo/libgeotiff/releases/download/1.5.1/libgeotiff-1.5.1.tar.gz"
  sha256 "f9e99733c170d11052f562bcd2c7cb4de53ed405f7acdde4f16195cd3ead612c"
  revision 1

  bottle do
    cellar :any
    sha256 "f833648eceb8cb0070df9188fab7bb6211323bea2ea9eaa202385d8af02ee705" => :catalina
    sha256 "5feecdec004c5bc749dbc16c4dda70382b001ad1e64ab7035086cfb425abf231" => :mojave
    sha256 "f34254f5d27c0b074d1b74dc4c73baeb8c042b4126a0e7283b7e11911e0e0e0c" => :high_sierra
    sha256 "b8f77860ec5528e75e3c74991ec06885a65dd0fab8d9b153a2742c8696e7e43b" => :sierra
  end

  head do
    url "https://github.com/OSGeo/libgeotiff.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
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

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgeotiff",
                   "-L#{Formula["libtiff"].opt_lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    output = shell_output("#{bin}/listgeo test.tif")
    assert_match /GeogInvFlatteningGeoKey.*123.456/, output
  end
end
