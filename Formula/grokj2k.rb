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
    sha256 cellar: :any, arm64_big_sur: "c873fd04f1973d2c646ceda2d1bd4dfee3cf7fb20f44364c17e1721c44f995a8"
    sha256 cellar: :any, big_sur:       "a70cbcf73d42cb2cf765f8b256314b77f4c4613201a1dfc27d8d5fd3096b667f"
    sha256 cellar: :any, catalina:      "820946695610b3ce3b4c07cce88a553b773a16de1e9bdfeaf391497faff05e06"
    sha256 cellar: :any, mojave:        "bf594aca0d14702150c42b9dda2e378045d77ea10fccccbeb41c6f834ed2d637"
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
