class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"

  stable do
    url "https://github.com/OSGeo/libgeotiff/releases/download/1.7.0/libgeotiff-1.7.0.tar.gz"
    sha256 "fc304d8839ca5947cfbeb63adb9d1aa47acef38fc6d6689e622926e672a99a7e"

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
    sha256 cellar: :any,                 arm64_monterey: "3d173e746cacebaf4a9be10c49e9f2a0fa94808993d75e44ba9465e5739d2100"
    sha256 cellar: :any,                 arm64_big_sur:  "0f191bda555533ac59d14b262d66a7a874ed55f77a6dc96785150eed1e84f7fe"
    sha256 cellar: :any,                 monterey:       "227714a8d1abd87e7f1cf3905116501838da12f3dc5a160b90e8b149d32cfec9"
    sha256 cellar: :any,                 big_sur:        "0e37a3add2a8840aebaf25f5e3e365eaca77c0943722366f760d4bebbcbdfe95"
    sha256 cellar: :any,                 catalina:       "20f4e9268c9c5154858452b5d4d1764c042de0e53f5ee7ee45fb889b3754e7ec"
    sha256 cellar: :any,                 mojave:         "ae97cbd99b52140c77705d0acd1f2b1affd7ffd907e00d6f00f72eae2e61c292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8731b70f84b1e9daa9ac6c8747232d87c760bcb2be7eb83643cc6582e1163cc"
  end

  head do
    url "https://github.com/OSGeo/libgeotiff.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "proj@7"

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
