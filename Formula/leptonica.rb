class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.80.0.tar.gz"
  sha256 "ec9c46c2aefbb960fb6a6b7f800fe39de48343437b6ce08e30a8d9688ed14ba4"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "2772ab6d50bb48132db5bf6d2d7b4086058635c060392dc375b23769513ebca7" => :catalina
    sha256 "b6503796ec87ac555bb4c5278aa3c8bf6b5ef3c88d66da9a040c04e0cafdcade" => :mojave
    sha256 "01c2fe703b082f830fffec5f1d21d50d41c1c30967cb74e1bc0b744dcb72d50d" => :high_sierra
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
