class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v7.6.5.tar.gz"
  sha256 "fc6ffa80af02186828f36a41bcdbd01b11a1e6b44e26b25793eb4476b4fe599b"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  bottle do
    cellar :any
    sha256 "1c4919f407ffadd6727bbbf4ed216f41228545167fa1a82096d4eefab917dbdf" => :big_sur
    sha256 "0e9306fc6d53a8287e68b9b7ce2c0781b5241dad730067faf1ceadf3278a5748" => :arm64_big_sur
    sha256 "27f44155a3f8e5f4dd6d08503f76ba376ffc6ef1689fefdfb599ca55d529c0fc" => :catalina
    sha256 "1136669a8671d8690a2bc86f94b9c0f0071496b3d54432500dc89b88e87b9840" => :mojave
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
