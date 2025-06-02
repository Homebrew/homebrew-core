class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "368fe0468228e767433c9ebdea82ad9d801a3ad1e4234421f352c8b06e7aa707"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8091181f4cdd66cc41e7c4bebdfb205c70fc52c069f8ddfdc26bc91e3fa417a"
    sha256 cellar: :any,                 arm64_sonoma:  "9597528b11f6ce50ea16e4b3baa4ff13dc018bccb63f9f8a8b788a5378059dcd"
    sha256 cellar: :any,                 arm64_ventura: "10a4d7d2b3201baa4762b09a3d399361a11685706e5428cd003d02489cf158b5"
    sha256 cellar: :any,                 sonoma:        "9c66e3db546bab6fbc2f277075f9a49f1bac10f757f1150e7820f63157c43f24"
    sha256 cellar: :any,                 ventura:       "5619b9551a495ddbe261ccbcf9e1e457c1eaa920b1e56b7af38775545c106bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bacf020994b0d334e1facae54af915d11d5cab319e745f4db5f9c39cab270758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccea9d571cc6a31c0d32b38608d8507f7b90b555faf276d61375844c6d38205c"
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
    (testpath/"test.c").write <<~C
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    C
    system ENV.cc, "-I#{include.children.first}",
           testpath/"test.c", "-L#{lib}", "-lopenjp2", "-o", "test"
    system "./test"
  end
end
