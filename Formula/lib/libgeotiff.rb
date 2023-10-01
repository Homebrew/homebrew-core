class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"
  revision 3

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
    sha256 cellar: :any,                 arm64_sonoma:   "c6e0a1796e5cd01960cef8ecbfa49080261a900e69dab8e64024922dea6d5faf"
    sha256 cellar: :any,                 arm64_ventura:  "8be2bc3923800b11fd54eadba98cc528d7938ed5595961784fa911b38b0e7d62"
    sha256 cellar: :any,                 arm64_monterey: "a684b1bf1a96b49fc931f226ac796878462981dfc0f1e2382266b3e11b30a63e"
    sha256 cellar: :any,                 arm64_big_sur:  "a917c710b51e42a7ee6a21a7c36da6fce310188638d44d168bf9cde2db7b66f0"
    sha256 cellar: :any,                 sonoma:         "6f428017ccc891b176a2967b4d29908ab3a2685c526c5e92c7dba3647500e7ee"
    sha256 cellar: :any,                 ventura:        "84ad9fc666dea682be3fe19e0910a4ec6c494da0a25f1ccaff65c83bc9aeda21"
    sha256 cellar: :any,                 monterey:       "5fc86bf32a1e9e9e228f8ef20dc82779d5923eb87b065cb7fd5ae772b805dfb0"
    sha256 cellar: :any,                 big_sur:        "e9ba1dffdcf7833cc9f91a9ecba376ec31e25d2e52cea76d7fdcfe927c511a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c0df2152deddcbb8a8be8b107b7e88ad8c4ad76c2266cf7d137ca5e8e86a5f"
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
    assert_match(/GeogInvFlatteningGeoKey.*123\.456/, output)
  end
end
