class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  url "https://github.com/uclouvain/openjpeg/archive/v2.5.0.tar.gz"
  sha256 "0333806d6adecc6f7a91243b2b839ff4d2053823634d4f6ed7a59bc87409122a"
  license "BSD-2-Clause"
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "46a9bf9f697e8e98a296cf25e3f6fc03d06c8814ad622b3d6e6cdf4df5ef4bd8"
    sha256 cellar: :any,                 arm64_monterey: "ad8a83dd4260c0c6cc941a04993b19e230aba83b7c200c9c8808c41d44f2bf93"
    sha256 cellar: :any,                 arm64_big_sur:  "4fb1a896ad5b273c2cb2b76960a78e1778c6e538f69e411c6cf8e20f5ada2184"
    sha256 cellar: :any,                 ventura:        "e615c2ae9510912562e40f3237822fdbe155a84309645d0df0990dffa7e6ff96"
    sha256 cellar: :any,                 monterey:       "7579e3c9665c0ff274336b0210f3fe87b03a72895b64840ef1565e69b975e48e"
    sha256 cellar: :any,                 big_sur:        "2b9a55147b5fc89120e86e499cf63425b7b3cac340fec050c19e287efb1f758d"
    sha256 cellar: :any,                 catalina:       "19d0029651a0dde2c307a8c50058bf8384879a2b94673272acc848faacde2a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e57a66212ac4fca6dd1c802c80cea7e3157157b16577d549f2b1f4001386ce7"
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
