class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.79.0.tar.gz"
  sha256 "045966c9c5d60ebded314a9931007a56d9d2f7a6ac39cb5cc077c816f62300d8"

  bottle do
    cellar :any
    sha256 "d9e27aab9e580e3f25f3be0c59f18aaa54b644c5886a7a1557d7bd2fda5003ab" => :catalina
    sha256 "0fc5ee0131143e0abe3b645ca69c23f8701787f0d60b2b28c0a4fdbbd5ce0913" => :mojave
    sha256 "53334591a3f5f47b0aba1ca1d9529bfd83bb05140784a34b3e4571d160483f06" => :high_sierra
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
