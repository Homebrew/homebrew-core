class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v9.0.0.tar.gz"
  sha256 "6b953571020e33b6aa9f963e88f7f538ae2f437b7f8987c5ee3e85e801c9c0e3"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a9221d88474870a7374385d536b47d017f6176a2b906f66c41ffdf60fd1850da"
    sha256 cellar: :any, big_sur:       "d2b7e0f587e0e8e6dad9d16b7a7435d861f66dcd88c9dcc65c86d120468a3153"
    sha256 cellar: :any, catalina:      "058a2a3fc9297afa0179ca6c249a32283157b42d821f0c1734694408ed317af7"
    sha256 cellar: :any, mojave:        "0b240fbe602ee2b6093314c51e350db24bc6a327c106be5eaa41c3d83fbfff98"
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
    include.install_symlink "grok-#{version.major_minor}" => "grok"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <grok/grok.h>

      int main () {
        grk_image_cmptparm cmptparm;
        const GRK_COLOR_SPACE color_space = GRK_CLRSPC_GRAY;

        grk_image *image;
        image = grk_image_new(1, &cmptparm, color_space,false);

        grk_object_unref(&image->obj);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{opt_include}", "-L#{opt_lib}", "-lgrokj2k", "test.c", "-o", "test"
    # Linux test
    # system ENV.cc, "test.c", "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"
  end
end
