class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.4.0.tar.gz"
  sha256 "8702ba68b442657f11aaeb2b338443ca8d5fb95b0d845757968a7be31ef7f16d"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "43c37565eb2eec2b41dee3f1cc26e3324a42a368cb88092fe1b0dbc941f7678f" => :big_sur
    sha256 "b57a02c3bc4ee8a43e47df5015e6e40a04d7149e172806157e279b1b03c715ef" => :arm64_big_sur
    sha256 "80426609c75b98ee0ee394e9017bb621dc73dd2d6f60d0c851f6940d0b268676" => :catalina
    sha256 "e26d092b6177ee282d3724dea5ea4cb76af3645472791c3fefb002e2638588b0" => :mojave
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
