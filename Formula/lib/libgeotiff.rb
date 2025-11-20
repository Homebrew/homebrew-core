class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"

  stable do
    url "https://github.com/OSGeo/libgeotiff/releases/download/1.7.4/libgeotiff-1.7.4.tar.gz"
    sha256 "c598d04fdf2ba25c4352844dafa81dde3f7fd968daa7ad131228cd91e9d3dc47"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4845032ded85e98d5076c95ca25441cd055d761c691a033f90e6fa5d3accfbc"
    sha256 cellar: :any,                 arm64_sequoia: "35a86c6a604a2d7f6d10bda3ba1fa47fa979896f3fc5ffcc2e9a06fa8047435c"
    sha256 cellar: :any,                 arm64_sonoma:  "9fc225c5ac0450cd685bab5f3834c52e9e321e8196886a500ee1be098263f388"
    sha256 cellar: :any,                 arm64_ventura: "7da423615ca23a18fd337ec4ca74e30d4c0674353b0c67ab90d4773036ab6028"
    sha256 cellar: :any,                 sonoma:        "d6537ddbe3f8af5599681df8bd75b1ab3e92a49693f777a50ac527aa15b56e50"
    sha256 cellar: :any,                 ventura:       "26be05be540553b47c9d8defc465c7be5d9b44c6b1c2698356d8327a8f117dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d29727b80535b2ca64f493348e0e8fcbfe704eb1f34e542c3a5a14b6c791f85f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ee650205449595ed8207f93c753bbeb77b1669d00a7f8f9bad9ddf9442840c6"
  end

  head do
    url "https://github.com/OSGeo/libgeotiff.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "proj"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--with-jpeg"
    system "make" # Separate steps or install fails
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgeotiff",
                   "-L#{Formula["libtiff"].opt_lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    output = shell_output("#{bin}/listgeo test.tif")
    assert_match(/GeogInvFlatteningGeoKey.*123\.456/, output)
  end
end
