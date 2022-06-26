class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.4.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.4.0.tar.gz"
  sha256 "917223b37538959aca3b790d2d73aa6e626b688e02dcda272aec24c2f498abed"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2dfbad3fe68e070d0937c71b4de6ca110dda32599a2adfc2272f31064ae8652"
    sha256 cellar: :any,                 arm64_big_sur:  "1b4a904ccd6042e3871194acf467dbfcd97096681d1c830331d1e807dfac924b"
    sha256 cellar: :any,                 monterey:       "0498f901409378a7900653a581fba3f0779e37bd64337f45816764750ae90aa3"
    sha256 cellar: :any,                 big_sur:        "fd49c31878df480848e8107055b88dfebb2d4eb6fab522837dd80f92783f452c"
    sha256 cellar: :any,                 catalina:       "cda7e1362bdf822a2dcaa449edd2f03cf520d82c62f8f7ec82fe9cca35cde3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa756f41864cae38e3c74b29b857f7c2f081a3b9eabd1c551cd6e39e12fd17bf"
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
