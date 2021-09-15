class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.3.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.3.0.tar.gz"
  sha256 "0e46e5acb087ce7d1ac53cf4f56a09b221537fc86dfc5daaad1c2e89e1b37ac8"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bd25355f2efb850a0e70c9ae208f0cd16caa0bfcaba8931d9ea9d374c5cf050a"
    sha256 cellar: :any,                 big_sur:       "09f08e1168780c12c8f1526038eb4f4692624c85a9e78099b8ae2c58e39f5289"
    sha256 cellar: :any,                 catalina:      "e413c1170e33242eb941683d14ae51de594a013b8c6e5151f53b3352358b26fe"
    sha256 cellar: :any,                 mojave:        "06248bbf04ff5180541a90d60bae68246b5f1665d42909be471fdc9a6781a718"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e63441d702b567a622495e391564b7bc1f2352501fe982709469c6f609a6abb0"
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --disable-webp
      --disable-zstd
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
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
