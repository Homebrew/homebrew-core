class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.7.tar.gz"
  sha256 "bff1fa140f4af0e7f02c6cb78d41b9a7d5508e6bcdfda3a583e35460eb6d4b47"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3cbdbbd65ceb35b81035c0dd3383e60e8e7a3669c7e401c7321f0fcf6e7df3c"
    sha256 cellar: :any,                 arm64_monterey: "41c9b6b892652ca0029a04a274fae07f53cb87829837265ce0bb6ae71b3893da"
    sha256 cellar: :any,                 arm64_big_sur:  "87b27a37039375081ecf88ab3efd78835b5d6d9bff8bfc13e73f0eb152dd83dc"
    sha256 cellar: :any,                 ventura:        "db0c7b03a7c218097c50e929280a33d82a4bb6e817a0ebf7170b0fc83c10cc27"
    sha256 cellar: :any,                 monterey:       "5e9e860b0156cf2cbab7eef8c4fe2d068c192b522b348958d3a1ab8f4c7130eb"
    sha256 cellar: :any,                 big_sur:        "78460fe6dfcdd140b61a1cf9ee44a04df43911e5550e9f95961b267f1d8b931b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f650fac2f979a3eda5d86c9d0e98687a987428fac960659844f5bc831feb8d8c"
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
