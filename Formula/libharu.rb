class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "a2c3ae4261504a0fda25b09e7babe5df02b21803dd1308fdf105588f7589d255"
  license "Zlib"
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99295cb20bb4c7a8d7f7d2ba07dfca6ba604bc73ef16a1352ab89a66164de4a2"
    sha256 cellar: :any,                 arm64_monterey: "9b275ece58d1b13804e5f24c4907afb98fd903b9fbaf767ae10064fdfc4abce5"
    sha256 cellar: :any,                 arm64_big_sur:  "5d7ddfa53783e144e70d05966047cf45a0779085aa5abaf1d3bc69974e16bee4"
    sha256 cellar: :any,                 ventura:        "d9bbee944dd85603f7a58a3924fac5ebb607196aa9d6935fcd410090e0df655a"
    sha256 cellar: :any,                 monterey:       "993cd8d5890d997b5594b477fd40453c31cda32402439ac6a83506505d8df9aa"
    sha256 cellar: :any,                 big_sur:        "8d9f255db0ee0ffd1c667832130c06c624f791e5dc06dd68befb307388ffd0af"
    sha256 cellar: :any,                 catalina:       "df8db49c177e2d6990469d150286114ac08395b3384ec7dcc60963a92c223ff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76904ae9e570b75c529f747aff8870c0db1dfc91be5054516b6a3afb52451297"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  uses_from_macos "zlib"

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build-static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build-static"
    lib.install "build-static/src/libhpdf.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hpdf.h"

      int main(void)
      {
        int result = 1;
        HPDF_Doc pdf = HPDF_New(NULL, NULL);

        if (pdf) {
          HPDF_AddPage(pdf);

          if (HPDF_SaveToFile(pdf, "test.pdf") == HPDF_OK)
            result = 0;

          HPDF_Free(pdf);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lhpdf", "-lz", "-lm", "-o", "test"
    system "./test"
  end
end
