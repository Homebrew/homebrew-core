class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "https://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.10.tar.gz"
  sha256 "2c52d11ccaf767457db0c46795d9c7d1a8d8f76f68b0b800a3dfe45786b996e4"

  bottle do
    cellar :any
    sha256 "c5612fcd5e15ca183583acaa5d0bd669a2f925e605b752ecf14cbfa1c84734b9" => :mojave
    sha256 "948a1f8f1d24d0dabbbc073a3052d0bb7648a6ed44898b40e1eab441d0bc8fb0" => :high_sierra
    sha256 "92311bfb3858958c40c494dda8da45c4937c5a792636e2f741c0394d4e31e7c5" => :sierra
  end

  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  # Patches are taken from latest Fedora package, which is currently
  # libtiff-4.0.10-1.fc30.src.rpm and whose changelog is available at
  # https://apps.fedoraproject.org/packages/libtiff/changelog/

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
