class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.81.1.tar.gz"
  sha256 "0f4eb315e9bdddd797f4c55fdea4e1f45fca7e3b358a2fc693fd957ce2c43ca9"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.leptonica.org/download.html"
    regex(/href=.*?leptonica[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0ebd69c5e282b631a62ffd868c213b799f57cdc407ceb8c271b9c9ed9c874af3"
    sha256 cellar: :any, big_sur:       "0ee29b71d9af543f85eabdf47dcc5558d8c184952568829f9a80597175881525"
    sha256 cellar: :any, catalina:      "d599f8a9fb024074c9ced4de01cd31deda663880996c86be75a0fa0695455ae3"
    sha256 cellar: :any, mojave:        "55f93e29a1195153d6408b3ceb27803b65417a438864b6305011b270ce034786"
  end

  depends_on "pkg-config" => :build
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "webp"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-libwebp
      --with-libopenjpeg
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <leptonica/allheaders.h>

      int main(int argc, char **argv) {
          std::fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
