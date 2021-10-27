class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "0bf7ec51162c4d17a4c5b850fb3f6f7a195cff9fa71f4da7735f74d7b5124320"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8932b50d2bd8e5e650b8b4076f62840b640f0440462f05f8068a2aa52333f2d0"
    sha256 cellar: :any,                 arm64_big_sur:  "2a2e81873d2de90b295234a6d639d8c61c375253c739328f54856477dad5193e"
    sha256 cellar: :any,                 monterey:       "5a09244b12f24ded2ab4056d302ecf30dacb0b06a0f45c2817cf56ed70da64ec"
    sha256 cellar: :any,                 big_sur:        "0a0b0dfa316ca1c7b122de50f6a3bb8d5f2827056c2981d8b69f49d63bc6fe47"
    sha256 cellar: :any,                 catalina:       "485012850077bef28aa6116a27868877c5c4e2b133081cae290804efd0bb7667"
    sha256 cellar: :any,                 mojave:         "ae767801f200cee72351c40a60bcb48a9441870c5d2d7c4da844b6da44057d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a188909af0b84e99692180e0c786a2e281d0a86f1155b14a074935ba32a33cbc"
  end

  depends_on "cmake" => :build

  # These used to be provided by `ilmbase`
  link_overwrite "lib/libImath.dylib"
  link_overwrite "lib/libImath.so"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}/Imath", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
