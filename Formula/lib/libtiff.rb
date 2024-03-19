class Libtiff < Formula
  desc "TIFF library and utilities"
  homepage "https://libtiff.gitlab.io/libtiff/"
  url "https://download.osgeo.org/libtiff/tiff-4.6.0.tar.gz"
  mirror "https://fossies.org/linux/misc/tiff-4.6.0.tar.gz"
  sha256 "88b3979e6d5c7e32b50d7ec72fb15af724f6ab2cbf7e10880c360a77e4b5d99a"
  license "libtiff"

  livecheck do
    url "https://download.osgeo.org/libtiff/"
    regex(/href=.*?tiff[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a9cafbce08b697fb25e326ea1dd3a0e01c3acc3f8f616e844940e49b33386ab3"
    sha256 cellar: :any,                 arm64_ventura:  "12f3e1b0e5cd225a05d914692cf6de0f86f29ba1f51b806723237da2f85a7b13"
    sha256 cellar: :any,                 arm64_monterey: "8a7ed5ea7efe9534f15bca3ae2134d9f35bd08372da5949c33d025f80ae1d47e"
    sha256 cellar: :any,                 arm64_big_sur:  "53b3bed3893804a56efa2ef20af3c2087298ba313b44e4cc6531d0bcfc54aaa9"
    sha256 cellar: :any,                 sonoma:         "a89a2671064dbf7af6b84a9f2d20546b3dff82ed4b6f95c17bdfe48ce6c615fc"
    sha256 cellar: :any,                 ventura:        "7347c37cf98bec3f956296caee0ecee54e7bfcc7b32d6e2e02b9ae04c80e3ca6"
    sha256 cellar: :any,                 monterey:       "8e3e1d5d4da3485867a6e0e2b35cf79e37f1b00e3e5399cf9b36996b1cbbff0c"
    sha256 cellar: :any,                 big_sur:        "e0e6f2c0bc25665bfffb66505ebc9fc410aeeed3435edf770e9ecee88c7bc0e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a6e0bb56c39b72a33b0a5629dc3fd49e4f1391513bcf7d04a764523cc0321c8"
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
