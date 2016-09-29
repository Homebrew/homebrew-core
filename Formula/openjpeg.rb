class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "http://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz"
  sha256 "4ce77b6ef538ef090d9bde1d5eeff8b3069ab56c4906f083475517c2c023dfa7"

  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "4e27fbf3c861435a3413a9ce6a32dd2336b666fb046278eb72711176cb10ecad" => :sierra
    sha256 "7d4ac6ba6dceae7f22d1f477abc8e4c3039324382d7029df71bd8f380f4e94d3" => :el_capitan
    sha256 "6e5766dd0f55d5cee1406ad8919ffc89fe3a701a2a4dd2cdd836abb34d753ae6" => :yosemite
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
