class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "http://www.leptonica.org/source/leptonica-1.79.0.tar.gz"
  sha256 "045966c9c5d60ebded314a9931007a56d9d2f7a6ac39cb5cc077c816f62300d8"

  bottle do
    cellar :any
    sha256 "2e53934abea2e776f9b532f4ea9d56c12e0bbbd83a54f56aa74de3393450dc11" => :catalina
    sha256 "29985739b8eb8fdc9e927bfe95f5ed63c0f11a48f693b8af0210efce4b5d7742" => :mojave
    sha256 "715a73dfeab21b60423385a51a400e815857742c4902b4d875083a50bc971354" => :high_sierra
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
