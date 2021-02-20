class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v8.0.0.tar.gz"
  sha256 "53186179af96c2e2cd05bf11d326f5d90d6fffb84d79aa2895d21c7dde50f173"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "30ac7010a5570e75b2d1c09cfea74236f890ff3cfac1014f5fb7f9e8592bfd0b"
    sha256 cellar: :any, big_sur:       "0cc010fcdf830c6b2a02c8bef682142b745105c7f07738bd1c4d5d2183bda83e"
    sha256 cellar: :any, catalina:      "2311264a7a99c567b12594b79bd75768b716ff851e00e53aefd3aee38e39b6e9"
    sha256 cellar: :any, mojave:        "b5198c476988a112b3b226805c601006d5124b034cbbf55a09503996d52c3d9b"
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
