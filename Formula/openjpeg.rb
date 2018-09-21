class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz"
  sha256 "3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "7626f5d3c63cade331daf83d8394ecf85f7bc3b715b4f06d297506ebd7f84ac1" => :mojave
    sha256 "87762c08c68afefa25166be5d0727a052fd6ad628b25a2d1d57d54b42e3b06d3" => :high_sierra
    sha256 "66694c288e9c15f54ab8332183d4d15ea204623dd13a5acadb211eef28cd5076" => :sierra
    sha256 "b5041fc90ace09f0b556072ce5fedfa99ff9025f031a4eb70fdee5b90f9aa438" => :el_capitan
  end

  option "with-static", "Build a static library."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"
    args << "-DBUILD_DOC=ON"
    system "cmake", ".", *args
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
