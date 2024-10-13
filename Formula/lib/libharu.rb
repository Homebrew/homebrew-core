class Libharu < Formula
  desc "Library for generating PDF files"
  homepage "https://github.com/libharu/libharu"
  url "https://github.com/libharu/libharu/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "227ab0ae62979ad65c27a9bc36d85aa77794db3375a0a30af18acdf4d871aee6"
  license "Zlib"
  head "https://github.com/libharu/libharu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "72ed7673beee330f8ade885552a080b59ce3c1fc3cc161e7cb0588c086291bb1"
    sha256 cellar: :any,                 arm64_sonoma:   "e4b858b562266a0505c2cfcf35cd0ce115fa96389a9f003e8cb9467d0a11a030"
    sha256 cellar: :any,                 arm64_ventura:  "aa47accfc4c264abadf915678fea03c4e1ab2b26337c45e64309e67b877f0f99"
    sha256 cellar: :any,                 arm64_monterey: "c7d14744968e672370f3beb7bfab56799ef5ca933a47b88076cb1278b88e2f9b"
    sha256 cellar: :any,                 arm64_big_sur:  "dc6537336d278f2d6f765f8d3813aff20d4d7d964fa7173d1501f043d3a7692f"
    sha256 cellar: :any,                 sonoma:         "bbb1ff1d6931b3978945d4153209b44205a9aea49a49eb58a10bb7d7996da4fa"
    sha256 cellar: :any,                 ventura:        "f9c1c32e65c90f56242be549c70836c9f18ea38a54baaeebb0c78da5f6b3dcef"
    sha256 cellar: :any,                 monterey:       "42ef7186005b05bff5aa26a415b5cf4f3812b75a9f2797d9a13b336c70bd0f56"
    sha256 cellar: :any,                 big_sur:        "96e3ea582ff115742396fba648f75468e41ebc9f6366a0db3127d50f57751cb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b88bead6378993ba8a58e180619b1604a899bc94f3724df4b0a1a78c7c97f890"
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
