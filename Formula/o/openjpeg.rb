class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.4.tar.gz"
  sha256 "a695fbe19c0165f295a8531b1e4e855cd94d0875d2f88ec4b61080677e27188a"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e9becf9b440b08fd771dbaa75d4f5b06a49119f9ce163e6ad08f272f4f3b9c9d"
    sha256 cellar: :any,                 arm64_sequoia: "8e3ac331458daccf876225a4236bad7d28689ea197c6bb7d2640ec47d78a510d"
    sha256 cellar: :any,                 arm64_sonoma:  "0eff9d5aae88cd27eaaedb4a4f56804ae14c4ed9df1c856846ff81ebc3dcb4c2"
    sha256 cellar: :any,                 sonoma:        "29b22e2c699765b32b3511f65bd87f6860d6bbf5f5f75e3b3ed5e268f6a547bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b570231cdd2898452318819d0dc97662145a463e0ba3162a113163e0f0066e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1906cdeecd5edc87703596cc084dc305834b030af3847a8520f9eb8566eb1e"
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
