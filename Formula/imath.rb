class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "9cd984bb6b0a9572dd4a373b1fab60bc4c992a52ec5c68328fe0f48f194ba3c0"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "f69d88d25f012ccdd25c4a7036ebdc5deb2172d2d462cca5795a705d2f0b8a1e"
    sha256 big_sur:       "d821e18ce9ea2dccf94a43d7facd5a2fd7e3ab327e066ee02d21676d2931262e"
    sha256 catalina:      "567b606d357b6b959d3ce32e5abe3abcd9b1d43494d7c11a7f48726657a47fb1"
    sha256 mojave:        "fd2aa308bbed5163af6fc50dbb9c3af3f9a5f3aaff0b29b1e71c4019c661ea87"
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
