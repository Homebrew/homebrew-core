class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://geotiff.osgeo.org/"
  url "http://download.osgeo.org/geotiff/libgeotiff/libgeotiff-1.4.2.tar.gz"
  sha256 "ad87048adb91167b07f34974a8e53e4ec356494c29f1748de95252e8f81a5e6e"
  head "https://svn.osgeo.org/metacrs/geotiff/trunk/libgeotiff"

  bottle do
    sha256 "e132dbc428f2ab5fb85099983b1558954f6bcf71e9acf2c65beb02b4c9cda198" => :sierra
    sha256 "56bef37d2a51e3af48a53c43d6610618c8f75040cb53e7716f3e02e8b15fceea" => :el_capitan
    sha256 "2b1d937bf755a56f048fdf7ea221485e5acd104e595433b8f02e90baf6db979a" => :yosemite
  end

  depends_on "libtiff"
  depends_on "lzlib"
  depends_on "jpeg"
  depends_on "proj"

  if build.head?
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}",
            "--with-libtiff=#{HOMEBREW_PREFIX}",
            "--with-zlib=#{HOMEBREW_PREFIX}",
            "--with-jpeg=#{HOMEBREW_PREFIX}"]
    if build.head?
      system "./autogen.sh"
    end
    system "./configure", *args
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

    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-lgeotiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/GeogInvFlatteningGeoKey.*123.456/, shell_output("#{bin}/listgeo test.tif"))
  end
end