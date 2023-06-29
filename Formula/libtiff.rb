class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.5.1.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.5.1.tar.gz"
  sha256 "d7f38b6788e4a8f5da7940c5ac9424f494d8a79eba53d555f4a507167dca5e2b"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9ec64c61687ec04d3d98e017c2a7ec5c23ff8a061cdeaf54209197fdbfa53e7"
    sha256 cellar: :any,                 arm64_monterey: "d5de595a3c6f8564e7164e07909374b376a954c360e2c5232ba1431b3ed4de98"
    sha256 cellar: :any,                 arm64_big_sur:  "760ba837679b14af360309108cdc3e682ddfed4c969ac1cec744927a7fcab67e"
    sha256 cellar: :any,                 ventura:        "d802af35e9f79c5a0d230862219aa237761c310354ca181dc21ef80b4f35da40"
    sha256 cellar: :any,                 monterey:       "78185275989220e1296ebe0f9aa6f3200c028f208fe0c0a6f3a5bedcf26ae751"
    sha256 cellar: :any,                 big_sur:        "18bd9c73f730afa03c4c5dd3c9b23d810a827e32464d325beafd1499161e47ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e9e7ee377e29c7417acc0399c5d38ebeb282b5c1516a69cde4e4b1803954ee"
  end

  depends_on "jpeg-turbo"
  depends_on "xz"
  depends_on "zstd"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-webp
      --enable-zstd
      --enable-lzma
      --with-jpeg-include-dir=#{Formula["jpeg-turbo"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg-turbo"].opt_lib}
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
  end
end
