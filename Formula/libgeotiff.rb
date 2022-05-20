class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"
  revision 1

  stable do
    url "https://github.com/OSGeo/libgeotiff/releases/download/1.7.1/libgeotiff-1.7.1.tar.gz"
    sha256 "05ab1347aaa471fc97347d8d4269ff0c00f30fa666d956baba37948ec87e55d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "615f768061ab2ac581ccb0e574d9f7fdde6bbe16e22b4ee8062d25b48410f967"
    sha256 cellar: :any,                 arm64_big_sur:  "d8442fb7541204b9ede5e102c854baf3157cc4813e8fa9975b9a8e13052f59c5"
    sha256 cellar: :any,                 monterey:       "90a3a8ab11c000fd87ea68a11a110175aa38053c6ef3e8a11be68bf9ffc67814"
    sha256 cellar: :any,                 big_sur:        "05347cfdc6122b60956c631a067fadc51f07c6d8362edf26aaa0c073895292f9"
    sha256 cellar: :any,                 catalina:       "bbdddfdbecc383bdac026cb0769c7148ef34f921accfe83d0b29bce17c44829b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84070c619a3a8cfb9cec0960d5431cb83570713999462fbd4d8a0d15857e32f"
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
    assert_match(/GeogInvFlatteningGeoKey.*123.456/, output)
  end
end
