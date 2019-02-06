class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz"
  sha256 "3dc787c1bb6023ba846c2a0d9b1f6e179f1cd255172bde9eb75b01f1e6c7d71a"
  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fd11438ec644bba47014568565171ec2d14926031f0976cb2b38332be900699d" => :mojave
    sha256 "610054f41d6111a6c9bcdb87b7f41495f416c5c570fb089fe37d1687dbc7f647" => :high_sierra
    sha256 "6fd55ac1165e6c06b0f71d0c0612c8bf0fc9ff8a4686b944e119bb9368412150" => :sierra
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
