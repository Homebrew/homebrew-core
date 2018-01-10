class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.9.tar.gz"
  sha256 "6e7bdeec2c310734e734d19aae3a71ebe37a4d842e0e23dbb1b8921c0026cfcd"
  revision 1

  bottle do
    cellar :any
    sha256 "3fba691b7c0df7b8dc941749ea5f4e4c3db3ca0b445412b0cb575aa3b1b71d37" => :high_sierra
    sha256 "b4972b2e2a693b080518b3e2f4e749df550cbd5b4b9cd8e5773d2debce90ed69" => :sierra
    sha256 "bffb176a37a98cc2eb75bd625d764775ff84dbef73276e7cd4fb4fb82d838b2b" => :el_capitan
  end

  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # All of these have been reported upstream & should
  # be fixed in the next release, but please check.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tiff/tiff_4.0.9-3.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tiff/tiff_4.0.9-3.debian.tar.xz"
    sha256 "c413f5b2423b95d8b068adca695f0ddaea5219088a1d38de4800b379bc20ca73"
    apply "patches/CVE-2017-9935.patch",
          "patches/CVE-2017-18013.patch"
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
