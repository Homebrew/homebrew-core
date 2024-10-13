class Libgeotiff < Formula
  desc "Library and tools for dealing with GeoTIFF"
  homepage "https://github.com/OSGeo/libgeotiff"
  license "MIT"

  stable do
    url "https://github.com/OSGeo/libgeotiff/releases/download/1.7.3/libgeotiff-1.7.3.tar.gz"
    sha256 "ba23a3a35980ed3de916e125c739251f8e3266be07540200125a307d7cf5a704"

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
    sha256 cellar: :any,                 arm64_sequoia:  "bdd218c9fa26e091337f57d4cf1cf60293a885fe7a70d49e7ed62c973a66fb94"
    sha256 cellar: :any,                 arm64_sonoma:   "331afc789e13b0ccf8260d5c85d68d4cec97d11320fee880bf472c1326de0c27"
    sha256 cellar: :any,                 arm64_ventura:  "606dfa6c652bbd07c5dc8fbb2efea2fc8e29fd95fca9ea2ba11a3b70d0e1e6a8"
    sha256 cellar: :any,                 arm64_monterey: "3dfe3caf669b158e180892b06ccc81cb7eef1fafa76281b6235f697c8e6ed569"
    sha256 cellar: :any,                 sonoma:         "3a23a973aeda8bd930a9124214d9f962fddc0e1d319d10098bd784aa7d2a8093"
    sha256 cellar: :any,                 ventura:        "e70694e0333a004285351949eb6939e88bbe5f81de205efe428468a56d775e3f"
    sha256 cellar: :any,                 monterey:       "cc17963344ed889fcde8c72b0037386ac54c08f60d83b8019387de0a3af9ef76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4a823390e8a4b884b499c9a17847db282646e6d108f524124e8e8863796736"
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
