class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.4.0.tar.gz"
  sha256 "8702ba68b442657f11aaeb2b338443ca8d5fb95b0d845757968a7be31ef7f16d"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "7f242d562de5b4dd5d0fb2392e2b8b0cc3fe7e2e719578481574f9524774f124" => :big_sur
    sha256 "fca1b4a39ac03461d8e942420a84f8a67b509862e000c3348bae77658d32b7af" => :arm64_big_sur
    sha256 "29b9e0e1ed01683fd26a2fb07d7ee354d8d236033305d8b0ca1dd5f36568fc65" => :catalina
    sha256 "6de317bfef3ab808ff5f3eb9c1aa47f77e7236fba8ad0d606b29b38eb47c321e" => :mojave
    sha256 "1eb8b2f698ecf16196e06a2d9f7ba20eb7f0ba447d351e36eb3344d3ed6c5c58" => :high_sierra
    sha256 "d2b377424ff5387892bc1af653654fdcc70702e4524f3309b3f0874ac6e2d84c" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_DOC=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}", "-L#{lib}", "-lopenjp2",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
