class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.9.tar.gz"
  sha256 "6e7bdeec2c310734e734d19aae3a71ebe37a4d842e0e23dbb1b8921c0026cfcd"
  revision 2

  bottle do
    cellar :any
    sha256 "b25a0893acdffc8fcbb1f9d0a2f1ef04c62f15168689fc64842cd7a36884d179" => :high_sierra
    sha256 "4fbaa643a091abe7e6744ff8b04dcd94d35b559874dcdc9d733b10c41666c78a" => :sierra
    sha256 "fdfeb67c92d2cb64628ba15c3ded9d840b90b5627e06e0864536fd66ea9d15f3" => :el_capitan
  end

  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # All of these have been reported upstream & should
  # be fixed in the next release, but please check.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.9-4.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.9-4.debian.tar.xz"
    sha256 "f078da1da538109c1e5403dc1f44d23c91f5a5d6ddc5ffc41ff60de006cb2b2e"
    apply "patches/CVE-2017-9935.patch",
          "patches/CVE-2017-18013.patch",
          "patches/CVE-2018-5784.patch"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-x
      --with-jpeg-include-dir=#{Formula["jpeg"].opt_include}
      --with-jpeg-lib-dir=#{Formula["jpeg"].opt_lib}
    ]
    if build.with? "xz"
      args << "--with-lzma-include-dir=#{Formula["xz"].opt_include}"
      args << "--with-lzma-lib-dir=#{Formula["xz"].opt_lib}"
    else
      args << "--disable-lzma"
    end
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
