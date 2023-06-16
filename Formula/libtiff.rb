class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.5.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.5.0.tar.gz"
  sha256 "c7a1d9296649233979fa3eacffef3fa024d73d05d589cb622727b5b08c423464"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a01418573c4dbf4ac60650c7fab3900127e8471e4fce6ee0cbfc33ec74cc04db"
    sha256 cellar: :any,                 arm64_monterey: "62a47b8372cd44881fd42ae569a24e54ce586a8f08fd5001b01e06598afcaafd"
    sha256 cellar: :any,                 arm64_big_sur:  "19a48db80f239f0053784cec21a56ac53d14ac087aa22e11d635e438a1f562c2"
    sha256 cellar: :any,                 ventura:        "3cf444bc3b46ad0df9ca926dc096df241ee1f61cd91c4e5ef847b24bd90e6920"
    sha256 cellar: :any,                 monterey:       "d76edd707b0e7b4a2f9f50f972081894d14bbbbee73ef2cfa4c944ac2f334597"
    sha256 cellar: :any,                 big_sur:        "a5d977aa7b41797ba50d7a9d4be3965fae8839a1b66e90b29fc7a23dd2017633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391ea7224b48f2f336d92fe6cf45b7d0651e2e5916257de223f7a85536ca3a65"
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
