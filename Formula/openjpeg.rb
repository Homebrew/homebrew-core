class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "http://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.1.1.tar.gz"
  sha256 "82c27f47fc7219e2ed5537ac69545bf15ed8c6ba8e6e1e529f89f7356506dbaa"

  head "https://github.com/uclouvain/openjpeg.git"

  bottle do
    cellar :any
    sha256 "2a9fa62441976f313c8bf85cd5f60bcdf0f4c1e61226bd7567cbf6277fa803f6" => :el_capitan
    sha256 "1dc66731ba58e187466506222f2959263e3940e003c013c1ccdf8d4d05895c65" => :yosemite
    sha256 "a1d280c45e2204cfd6236d465671fcfc0256ea971aefa1b6e0f3f65ffe7ad073" => :mavericks
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
