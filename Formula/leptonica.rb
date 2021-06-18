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
    sha256 cellar: :any, arm64_big_sur: "8511608a91a7ebf340b298e77dad939722963c939df1705d8eced03fe94baf6b"
    sha256 cellar: :any, big_sur:       "85f91f416da83686688c9a37758c8435564fec5cfc8f2c3a1106becc8c131502"
    sha256 cellar: :any, catalina:      "3a60ca40699a3ac1159cc3a52c09632b4c50bc5cf9f7291aff911dc66237624c"
    sha256 cellar: :any, mojave:        "1310af15c7bfc64222cc369e571a352b0e4f5131ba631f16cfe8f2ceb398b427"
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
