class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v9.2.0.tar.gz"
  sha256 "624828a4175e549a59aedc2c116479184d4f65247acef91bb79594aa6d9256cc"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "57cf9f32210c7e91ca190e4bbda85f414b418c4147cd91efed489d3cda3b9c20"
    sha256 cellar: :any, big_sur:       "54f0c28f937ee113ada68f1994b9ab045807b696691f613d4df12e82b574885b"
    sha256 cellar: :any, catalina:      "d6e29cc564dc39d7f78e63607573e3917e6b7d68e244c7aacdabd71267c21ede"
    sha256 cellar: :any, mojave:        "c69e43ac9946e7e0655a80183fe73c0c6236f9b196a6894e9bb28e61f6cce2f5"
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
