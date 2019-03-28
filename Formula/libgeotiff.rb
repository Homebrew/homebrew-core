class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "https://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.5.0.tar.gz"
  sha256 "1c0bef329c60f770ed128e8b273945100f1a4b5abd161ac61e93bc947b0624dd"

  bottle do
    sha256 "47115d53da7662fd9fdcb78f23b3c1e812ca4a8d61860beead5ba77c09e167a6" => :mojave
    sha256 "eae737268264c4631097b5dbb035c778864ecb9dba5a31425d30e80f5dba2381" => :high_sierra
    sha256 "25da616d5eea00acd1340c35fd9c37480c8f67bdeb3018ee10dcda2a616e07c3" => :sierra
  end

  head do
    url "https://svn.osgeo.org/metacrs/geotiff/trunk/libgeotiff"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "proj"

  patch :p2 do
    url "https://github.com/OSGeo/libgeotiff/commit/f4956251737b29ccc3f6366cd5b21520689f21d9.diff?full_index=1"
    sha256 "de383f5023f34262638d6069bf8f1be2cc05342313dad33aa9ff3c82e38b5934"
  end

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
