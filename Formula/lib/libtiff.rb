class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.7.2.tar.gz"
  mirror "https://ftp2.osuosl.org/pub/osgeo/download/libtiff/tiff-4.7.2.tar.gz"
  sha256 "672bd7d10aee4606171afb864f3570b83340f6a33e2c186dc0512f7145ffdf6a"
  license "libtiff"
  compatibility_version 1

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "2678f5bb80b0578e79c76f747b637781ab3629b0c393e8c7d060ead4d42f9d6c"
    sha256 cellar: :any, arm64_tahoe:       "9a0ff1ac153879e9fb324951f33fc52c797149a6de44176e4fb80f0c8adad9a8"
    sha256 cellar: :any, arm64_sequoia:     "e971adc15ce3387a9c68a10ff1cf431755faf0e86b9d3a6daf668efc2f6f31d8"
    sha256 cellar: :any, arm64_sonoma:      "4504c9c0fd45de525e9a532da674b703bda04d377d7471f70cf611954da1fb1d"
    sha256 cellar: :any, arm64_linux:       "076896f22523cb34a4c1f8488bd27049d57b30f6e0232c74578df432700d61f2"
    sha256 cellar: :any, x86_64_linux:      "565e06c1da5aca67e2993315807301afddd252372c0896b76be515895b3c053a"
  end

  depends_on "jpeg-turbo"
  depends_on "webp"
  depends_on "xz"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      --disable-libdeflate
      --enable-webp
      --with-webp-include-dir=#{formula_opt_include("webp")}
      --with-webp-lib-dir=#{formula_opt_lib("webp")}
      --enable-zstd
      --enable-lzma
      --with-jpeg-include-dir=#{formula_opt_include("jpeg-turbo")}
      --with-jpeg-lib-dir=#{formula_opt_lib("jpeg-turbo")}
      --without-x
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace lib/"pkgconfig/libtiff-4.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        TIFF *out = TIFFOpen(argv[1], "w");
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, (uint32) 10);
        TIFFClose(out);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltiff", "-o", "test"
    system "./test", "test.tif"
    assert_match(/ImageWidth.*10/, shell_output("#{bin}/tiffdump test.tif"))
    (testpath/"test_webp.c").write <<~C
      #include <stdint.h>
      #include <tiffio.h>

      int main(int argc, char* argv[])
      {
        uint8_t rgb[16 * 16 * 3] = {0};
        TIFF *out = TIFFOpen(argv[1], "w");
        if (!out) return 1;
        TIFFSetField(out, TIFFTAG_IMAGEWIDTH, 16);
        TIFFSetField(out, TIFFTAG_IMAGELENGTH, 16);
        TIFFSetField(out, TIFFTAG_SAMPLESPERPIXEL, 3);
        TIFFSetField(out, TIFFTAG_BITSPERSAMPLE, 8);
        TIFFSetField(out, TIFFTAG_PHOTOMETRIC, PHOTOMETRIC_RGB);
        TIFFSetField(out, TIFFTAG_COMPRESSION, COMPRESSION_WEBP);
        TIFFSetField(out, TIFFTAG_ROWSPERSTRIP, 16);
        if (TIFFWriteEncodedStrip(out, 0, rgb, sizeof(rgb)) < 0) return 2;
        TIFFClose(out);
        return 0;
      }
    C
    system ENV.cc, "test_webp.c", "-L#{lib}", "-ltiff", "-o", "test_webp"
    system "./test_webp", "webp.tif"
    assert_match "Compression Scheme: WEBP", shell_output("#{bin}/tiffinfo webp.tif")
  end
end
