class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  url "https://github.com/OSGeo/libgeotiff/releases/download/1.6.0/libgeotiff-1.6.0.tar.gz"
  sha256 "9311017e5284cffb86f2c7b7a9df1fb5ebcdc61c30468fb2e6bca36e4272ebca"
  license "MIT"

  bottle do
    cellar :any
    sha256 "181da2f2a3860b23ee95eded5a9f5600f34e2ee016e76a7fbede959e565d0ca8" => :catalina
    sha256 "7311abe41270eb90f91b69e84eab0528be0b76a11cc43ce0e2aca1529da585fe" => :mojave
    sha256 "b52ce34a76c3510314e840753610d5d423cd0689d5b93d3d41e7c119ba67d09b" => :high_sierra
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
