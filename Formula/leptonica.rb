class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.78.0.tar.gz"
  sha256 "e2ed2e81e7a22ddf45d2c05f0bc8b9ae7450545d995bfe28517ba408d14a5a88"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9941fc91bf580e0118af3781faaeb303e888465057fa5cf4184025e9342c04a8" => :catalina
    sha256 "e986663412d5f3e2e731766c6b90eaf586f343067787602e9a11361d998b4d24" => :mojave
    sha256 "9d07766fb8cb612838f4bc85801a106b7ba07b76bef30b68d5935aa9485076e4" => :high_sierra
    sha256 "5200d6f0a132a730aa552c128f8a9abd076f34568a70dc6bea7b042d2fa7b037" => :sierra
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
