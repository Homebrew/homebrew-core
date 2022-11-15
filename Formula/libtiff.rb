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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4f8764b4cf388d7fdf727b2c61d1b48efb43ba4d337949bf34a932c08361681a"
    sha256 cellar: :any,                 arm64_monterey: "b48b8b5166bc548be184e03892adf5259dad564bee1cb62ddb84c1bdf21caaeb"
    sha256 cellar: :any,                 arm64_big_sur:  "b887dbf7a606f138ef8ec2c328110ead07dea77452e71a1e89a50e25326215dd"
    sha256 cellar: :any,                 ventura:        "d93fb1487305afa278c639a94b4fde2090d02f45239a0fe4b2ca574bf9fbc684"
    sha256 cellar: :any,                 monterey:       "f110c775f85a880a30ff43f738df534ee76f5dc55cc62b902870515adf03f15e"
    sha256 cellar: :any,                 big_sur:        "ac18fea512fc702586831b2907910abd31573bc210231fd124945c05d7312921"
    sha256 cellar: :any,                 catalina:       "c9a4d1faa66a576710c10ef26cd970175a8ab20f8c80cd0e9265eb0dd1a2adec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c18c93cb64098dd7415e87fc3acd9a8db9a475c15202244cc9947b24ae66dd80"
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
