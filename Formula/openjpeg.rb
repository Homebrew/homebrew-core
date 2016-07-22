class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "http://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.1.1.tar.gz"
  sha256 "82c27f47fc7219e2ed5537ac69545bf15ed8c6ba8e6e1e529f89f7356506dbaa"

  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "50be982ed3846844ac93a34ebd159c680bed484f96b6c0ea274c2e88cc5501de" => :el_capitan
    sha256 "c9cc5b4f37fdf8b8fc1b043597ab6ac4aa30bfa8fde94b7b0d67a30f03a3cb1b" => :yosemite
    sha256 "92badbf4968bfda26318855b28940f564e60c701fe3b4e29bc4f173748da7476" => :mavericks
    sha256 "a30aa5b0a7ebcc1daba910671183084d69afb1d30cb85bfeb8b213f8e7a617d7" => :mountain_lion
  end

  option "without-doxygen", "Do not build HTML documentation."
  option "with-static", "Build a static library."

  depends_on "cmake" => :build
  depends_on "doxygen" => [:build, :recommended]
  depends_on "little-cms2"
  depends_on "libtiff"
  depends_on "libpng"

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
