class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.5.0.tar.gz"
  sha256 "0333806d6adecc6f7a91243b2b839ff4d2053823634d4f6ed7a59bc87409122a"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ca6ecfefa5412308685c26b756bb2ba3017e08fec8f598cf9921f250b7650c46"
    sha256 cellar: :any,                 arm64_big_sur:  "d75e9349dec836cacb65cd526b4102c42fb565a18a8f22258efc8ead7f02cb7d"
    sha256 cellar: :any,                 monterey:       "e67b786522a005da2e0588e14b1db6a655ac183b33997e3f74e8020454ed73bf"
    sha256 cellar: :any,                 big_sur:        "b57d2aae9396057846170004b7ac7048dd1fd3227bd0db8f332601416ec49180"
    sha256 cellar: :any,                 catalina:       "dfc408c7529b4b391de6fbce4b8e211ab30ba554267cebcbf975bc6dbd3ad6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "675a1e182e701f6a783d1407506558c7822bf6e377f7684d62eebd8fa23dfcb6"
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
