class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.4.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.4.0.tar.gz"
  sha256 "917223b37538959aca3b790d2d73aa6e626b688e02dcda272aec24c2f498abed"
  license "libtiff"
  revision 1

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15921731edaae9d13ca572f3e2b58e07ca6f90429cc5f1bdff56aaf061abe2e2"
    sha256 cellar: :any,                 arm64_big_sur:  "cda70e066b4b649d7b41654abfc46e8ed1c3740c54f3cf58f4e750a551dc94f7"
    sha256 cellar: :any,                 monterey:       "87bb203517b2d8a982cd2bcd96d8247d367a8de36c91faa8209371ddc27479b3"
    sha256 cellar: :any,                 big_sur:        "a56a4f0a3ad9a75a70a9458fd098ec7da793eb39fcd4877515b5163b6ece21b0"
    sha256 cellar: :any,                 catalina:       "e760184399d1f7c529dd921df16e9262ebcf2a56eba4c1bcccf248c23592239a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f7f37d60e465f801e13052f7e5177eac772f079ec3706ede00f8804c9d7ab3"
  end

  depends_on "jpeg-turbo"

  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-lzma
      --disable-webp
      --disable-zstd
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
