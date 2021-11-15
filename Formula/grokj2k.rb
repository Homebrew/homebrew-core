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
    sha256 cellar: :any, arm64_monterey: "262c7341aff1b3bcd6e5ca9fd373ed43f23926f6e606aca97bebc09485a126f5"
    sha256 cellar: :any, arm64_big_sur:  "0ff80b270e775a3f3e8e5711358293e1360430a3277b0a69b20eb6522e61e0a0"
    sha256 cellar: :any, monterey:       "0e7d0d7a2c08b753004ed5ea898dd6cba88212f12a15c7a2bfba5d8cfd403e5c"
    sha256 cellar: :any, big_sur:        "bb8a5620f4b6102088251cdaa9aa991d0fec06c9b9482fd2aa4a8232eb5afd95"
    sha256 cellar: :any, catalina:       "32efd38b670868596e67fe8c8b0649318acc83644d55452a088687e9676a5c7d"
    sha256 cellar: :any, mojave:         "028c9c864189cb90f43c422ba74f60c2297bb427f238713780c20a88adffc5c3"
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
