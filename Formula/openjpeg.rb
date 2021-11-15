class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.4.0.tar.gz"
  sha256 "8702ba68b442657f11aaeb2b338443ca8d5fb95b0d845757968a7be31ef7f16d"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "13b02f1e67d92a72a712a4cbeca0613c9467acef5e0a6c3ef45343988353c477"
    sha256 cellar: :any,                 arm64_big_sur:  "b57a02c3bc4ee8a43e47df5015e6e40a04d7149e172806157e279b1b03c715ef"
    sha256 cellar: :any,                 monterey:       "2dcf97a3d9df6686f006e9e9d471a71612da54a81de169dfc8b2dae83cfa2b79"
    sha256 cellar: :any,                 big_sur:        "43c37565eb2eec2b41dee3f1cc26e3324a42a368cb88092fe1b0dbc941f7678f"
    sha256 cellar: :any,                 catalina:       "80426609c75b98ee0ee394e9017bb621dc73dd2d6f60d0c851f6940d0b268676"
    sha256 cellar: :any,                 mojave:         "e26d092b6177ee282d3724dea5ea4cb76af3645472791c3fefb002e2638588b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6aa616b62f6b6bc7604afdbddb4b665a33230f3661d112d9bd441bbadc6e66e"
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
    system ENV.cc, "-I#{include.children.first}",
           testpath/"test.c", "-L#{lib}", "-lopenjp2", "-o", "test"
    system "./test"
  end
end
