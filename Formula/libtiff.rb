class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "http://libtiff.maptools.org/"
  url "http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.0.8.tar.gz"
  sha256 "59d7a5a8ccd92059913f246877db95a2918e6c04fb9d43fd74e5c3390dac2910"

  bottle do
    cellar :any
    sha256 "c3db59fa42ce59f90e0e509488498f40baeb3b3e618c6406342a4d5393fa2b0b" => :sierra
    sha256 "05d3e7bcbd90ca0ec4f4dfcf8bcafe65ff57c94eabda983d659ea2377a09756f" => :el_capitan
    sha256 "8366e2ffaa26a0f0723c8fa0ed6d6fec9b6909a97201090b3bd6fb3a888dc672" => :yosemite
  end

  option :cxx11
  option "with-xz", "Include support for LZMA compression"

  depends_on "jpeg"
  depends_on "xz" => :optional

  def install
    ENV.cxx11 if build.cxx11?

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
    (testpath/"test.c").write <<-EOS.undent
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
