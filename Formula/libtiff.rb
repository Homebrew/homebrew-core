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
    sha256 cellar: :any,                 arm64_ventura:  "cc6d07767e6e0536eec3ac5243194362d3b0a858221a3c3cb3639e4f7b0be34a"
    sha256 cellar: :any,                 arm64_monterey: "74f7135659b8204c8e672bf175a976b68da51cdf96d7efa3f5871c22db78c1c4"
    sha256 cellar: :any,                 arm64_big_sur:  "66d1c7e7453aba5775da8d024cda9427774bbb4acc2a0c09fe29575990467343"
    sha256 cellar: :any,                 ventura:        "05d54a1996c40e4454755e6c556f07cc88f80c31cca1eb603b644fe9ed35c80e"
    sha256 cellar: :any,                 monterey:       "0f326fe10765b62306181dfc1f3f947b6027ab571addd4eb0abffbf44c9e60f2"
    sha256 cellar: :any,                 big_sur:        "eee74ff95a0ce4df7891ff93b75a234724191a56368b2dcf650fbd3d91e31ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "279580bf022a892c617fa7682224b60b164b23b3112226ff169f3f809e1a4225"
  end

  depends_on "jpeg-turbo"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-zstd
      --disable-dependency-tracking
      --disable-lzma
      --disable-webp
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
