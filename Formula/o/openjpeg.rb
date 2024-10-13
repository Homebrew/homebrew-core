class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "90e3896fed910c376aaf79cdd98bdfdaf98c6472efd8e1debf0a854938cbda6a"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "7eee7407be56d3c1ed9b5ef6b325e36f768797b5436f4f1ff353b6126284ce49"
    sha256 cellar: :any,                 arm64_sonoma:   "eef55952d48f1852f5e95a4f8bf336019ebf3800d5dc0fba79cf85ae1fe475d6"
    sha256 cellar: :any,                 arm64_ventura:  "23d1814c74d0e84518faa642272a7b88a8b4e2e78e9fe8b3f3313483c180cbbe"
    sha256 cellar: :any,                 arm64_monterey: "f9aa864e7bb14b36df6d7f83f5f5a10a65c9fb6b4227d7e6edcdecb9af2263dc"
    sha256 cellar: :any,                 sonoma:         "db5e5cb9eac6d4f910b9845d8decbd3eb19ef25570eddaaec235a29c637ba929"
    sha256 cellar: :any,                 ventura:        "02d67cf70fb174e35ce003e3914b0c867ce8b5f0aafde47eb34d24edd4e5443a"
    sha256 cellar: :any,                 monterey:       "cf986cc726d5f07c6d033653ae19c27cc3cccc7e30dafc7cbb054ffe56fd0f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28c920d3a84fbe6254d89f3a2a15db655d700066565701e57ce3e9210a56b343"
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
