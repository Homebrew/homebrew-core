class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"
  revision 2

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
    sha256 cellar: :any,                 arm64_ventura:  "1fbb6a3e85a67d141f78bfdb537abe6ccd615b84893e8ad3caedaa7c0f0cf944"
    sha256 cellar: :any,                 arm64_monterey: "f7ba75c48d134bac69f1521df8ce1ee07b7f7bb5c383819d6864d444f9306503"
    sha256 cellar: :any,                 arm64_big_sur:  "f66e3548fd5092b3b1cdd90ce0a9dbc9749b368a9d350dcf6e4b4435f6e81fad"
    sha256 cellar: :any,                 ventura:        "628a49b7ae7f4f62b96b8078b302dc9fd0eb9925a3db8656f394bee2c458cf20"
    sha256 cellar: :any,                 monterey:       "8a49a864a5bbc5b5a2f42e62ad8111b7ca9c1e8f00fd2c44f2dcd9a4468224b0"
    sha256 cellar: :any,                 big_sur:        "f98f8f3d3b5286a238a30449b3ac2f6efed1830d78a346463e56c611a63f3747"
    sha256 cellar: :any,                 catalina:       "eaae52303ca7865b5b0d69e6c243fb7d8a13663b0f07c290bd33648cf587f53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8b839b1cbc82e1ae8f800c04d603e75bf43ed40cf516b11abb9ff08155286a"
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
