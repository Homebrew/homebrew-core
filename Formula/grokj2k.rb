class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v7.6.6.tar.gz"
  sha256 "669ca69aa70598ee1c4a1f7239efc0a4bc463275a150019baedd10b8440ec78c"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2febc4a50b8c379ad3dfe219fd1ab3413e6015ff54433f04c38daa591e81e055"
    sha256 cellar: :any, big_sur:       "59943006d3c14e3cd2b75dabf285238222c86900b4c72c74cd00a0224b2d5e60"
    sha256 cellar: :any, catalina:      "1ce8cf8743486cd836a4b6d9ed3a5c2e2081ede1a94d18e875f803aed95e3cb2"
    sha256 cellar: :any, mojave:        "9fb16262fb14af0d5da81d50baa735b145acd857a9d16c2ff672dd7ab96432be"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "exiftool"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_DOC=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <grok.h>

      int main () {
        grk_image_cmptparm cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_create(1, &cmptparm, color_space,false);

        grk_image_destroy(image);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "test.c", "-o", "test"
    # Linux test
    # system ENV.cc, "test.c", "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"
  end
end
