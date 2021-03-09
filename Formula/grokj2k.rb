class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v8.0.2.tar.gz"
  sha256 "ab16fee0d804fc0bf8e18d36a6ba6564d95881c5cc1d7139f9860a54f260f4d8"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c38f27380e8633dc06af79e97869771152befe679a03395d2eeb0f9f1f6d6f32"
    sha256 cellar: :any, big_sur:       "c207b015fa51aae98409aec36e87722f6af84976d165c68104d4acbe5158aaee"
    sha256 cellar: :any, catalina:      "d5035f0235962c3a19752cecc43f512b10fc765094eb09892cf8697e0d469295"
    sha256 cellar: :any, mojave:        "90d1fb0fb139c7cb29f702fdc8b0dddaba3d989b44e9266e88f3569c0e495168"
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
        image = grk_image_new(1, &cmptparm, color_space,false);

        grk_object_unref(&image->obj);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "test.c", "-o", "test"
    # Linux test
    # system ENV.cc, "test.c", "-I#{include.children.first}", "-L#{lib}", "-lgrokj2k", "-o", "test"
    system "./test"
  end
end
