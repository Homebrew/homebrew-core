class Leptonica < Formula
  desc "Image processing and image analysis library"
  homepage "http://www.leptonica.org/"
  url "https://github.com/DanBloomberg/leptonica/releases/download/1.77.0/leptonica-1.77.0.tar.gz"
  sha256 "161d0b368091986b6c60990edf257460bdc7da8dd18d48d4179e297bcdca5eb7"
  revision 1

  bottle do
    cellar :any
    sha256 "b57475fe16858c93395c7bc20dbd0494cf768c3e73713987990c9a51106d4db0" => :mojave
    sha256 "c7b6ba6ecfeed9ed6e42c6e83069be0aeea12e0afc5162950f154887d5297ba1" => :high_sierra
    sha256 "cebb1952b28481e8d8c31df505d9e342321819fec4e9c2690c37e1efa1063bbb" => :sierra
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
