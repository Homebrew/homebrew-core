class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "3b5cef518964755963550b5f4a16e7c0a0872574921b1443f1d47fdb6b8c5afe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4ded58db141913891432d2cc00d22db91fc179619e0823633d8dcb6d6355e751"
    sha256 cellar: :any, big_sur:       "c8ff0ac963b448ef81fd594fd34ac58786240e080c945e9a34dfaf91efb642f0"
    sha256 cellar: :any, catalina:      "c4b0dffc652c9d20269dc85738dd2271599ff9e14b564eb427fdb47411df5398"
    sha256 cellar: :any, mojave:        "f4565a5f16ac617f2268006e8c164051c80911ada75b08021f6ca19a153af359"
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
