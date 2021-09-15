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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "ab4697cba5d08068caf5bba23b6ab820708e7e141ab2a31b75c5218e0af4d683"
    sha256 cellar: :any,                 big_sur:       "584d359158d6c45de7caf2368f8fc5e3268b67511dbeb8531d6762b03a3efed9"
    sha256 cellar: :any,                 catalina:      "f73dceda2c8430f107f7d134cebd189684de1723639be81be2fd79ec3db07c34"
    sha256 cellar: :any,                 mojave:        "0009444bfbafb359608fef5bf861a275acb2cbbade511572c9c3d08043b7bac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28826ccd4ae01f0b0dab2b5c8b1f6ed3aa569c0238822b419b125cde45bc9e32"
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
          fprintf(stdout, "%d.%d.%d", LIBLEPT_MAJOR_VERSION, LIBLEPT_MINOR_VERSION, LIBLEPT_PATCH_VERSION);
          return 0;
      }
    EOS

    flags = ["-I#{include}/leptonica"] + ENV.cflags.to_s.split
    system ENV.cxx, "test.cpp", *flags
    assert_equal version.to_s, `./a.out`
  end
end
