class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "http://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz"
  sha256 "4ce77b6ef538ef090d9bde1d5eeff8b3069ab56c4906f083475517c2c023dfa7"
  revision 2

  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "e5d4bcad36795653f31a5deec4ed17ece781891d7421cb2841336ca48ce37d9d" => :sierra
    sha256 "6a2608996b46e5889a8ca154b03bd6af6e01efbdd54af269b41abb859e37bebc" => :el_capitan
    sha256 "b6321a8848d7d86113a32663bff217c2e12565ead59d1ecaf3cfe9b3d8fd8467" => :yosemite
  end

  option "without-doxygen", "Do not build HTML documentation."
  option "with-static", "Build a static library."

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "little-cms2"
  depends_on "libtiff"
  depends_on "libpng"

  # https://github.com/uclouvain/openjpeg/issues/862
  # https://github.com/uclouvain/openjpeg/issues/863
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/o/openjpeg2/openjpeg2_2.1.2-1.1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/o/openjpeg2/openjpeg2_2.1.2-1.1.debian.tar.xz"
    sha256 "b19b15ac6306c19734f0626f974c8863e4dc21a1df849a8ae81008479b5b0daf"
    apply "patches/CVE-2016-9572_CVE-2016-9573.patch"
  end

  def install
    args = std_cmake_args
    args << "-DBUILD_SHARED_LIBS=OFF" if build.with? "static"
    args << "-DBUILD_DOC=ON" if build.with? "doxygen"
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
    system ENV.cc, "-I#{include}/openjpeg-2.1", "-L#{lib}", "-lopenjp2",
           testpath/"test.c", "-o", "test"
    system "./test"
  end
end
