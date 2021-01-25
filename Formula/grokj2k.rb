class Grokj2k < Formula
  desc "JPEG 2000 Library"
  homepage "https://github.com/GrokImageCompression/grok"
  url "https://github.com/GrokImageCompression/grok/archive/v7.6.5.tar.gz"
  sha256 "fc6ffa80af02186828f36a41bcdbd01b11a1e6b44e26b25793eb4476b4fe599b"
  license "AGPL-3.0-or-later"
  head "https://github.com/GrokImageCompression/grok.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "034b2c793f856d59049c4d7881e2a103b3cbf9b8eac4bfd9becb48791a3cefc0" => :big_sur
    sha256 "19c78bad6000b558f34ee2518ecc4b38462c880c2710aef68c1c0f1858811262" => :arm64_big_sur
    sha256 "98bd1860f83919b21607c56dc7498331ff554869ecab73bb6cdade63979774cb" => :catalina
    sha256 "208b0a75763be1f139a7bccf5584cb7177b02f0c0e8c9f082dd99f1a5dba09f4" => :mojave
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
