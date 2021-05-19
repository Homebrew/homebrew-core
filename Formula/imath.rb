class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "296c4facd4e5022a937f9ac7c354d62f0d002d3bf47434e91c5ee5f4a4f8ee93"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bf74c8beb68eb922aeddf499c74e4b18a8ce618ea4c303417b68491dd9a5c812"
    sha256 cellar: :any, big_sur:       "25298747a55d555ed0db7a305307d6361ff80da2c3f9b551e0a9721719d6a3cf"
    sha256 cellar: :any, catalina:      "f19fe6b28833f6c6ef9f48486707627f64eb7767f292b29898666e7891cee825"
    sha256 cellar: :any, mojave:        "303283007d799d668967da6008d9354e4e10ab81565a823ace2fceb8900e3bde"
  end

  depends_on "cmake" => :build

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
