class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.5.0.tar.gz"
  sha256 "0333806d6adecc6f7a91243b2b839ff4d2053823634d4f6ed7a59bc87409122a"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51f1c5ccf3da558ed5ada2892dc6375faa5eb9cacbe086186aa9b4ecf5483f0c"
    sha256 cellar: :any,                 arm64_ventura:  "4608628e92a5691cd45550219c92def72e3543f372af39f88d1bda2b87a40f3b"
    sha256 cellar: :any,                 arm64_monterey: "d282881c43fc02cf689b945998c241ee41515bc82fd385d46cab912dc8975965"
    sha256 cellar: :any,                 arm64_big_sur:  "d76df626bb74bf01e69bdb9b5d863f20c9094739bba8cddcd9a9e056ffa2721a"
    sha256 cellar: :any,                 sonoma:         "7ac174c6d8b1d7b0350a184a53a5086208cb54bbdbe215ae263b36aa2511e3b7"
    sha256 cellar: :any,                 ventura:        "27de3314c1627971d0c3b29415b13fd0beb780b99749f119ebd95e1e8cfbe7f1"
    sha256 cellar: :any,                 monterey:       "e12b575ffdc93662111c2102110fb1ac067eba3b4f3fda90a01a253e66293c5a"
    sha256 cellar: :any,                 big_sur:        "cbcf47bf1a1dcae0b4331f2f213d278a042e717eafdcbc54f21c920fdc0b56bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47190a905d491fecfcc9133024ed9ca3fc4e43d15ec30a26560d0e43b4649548"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_DOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
