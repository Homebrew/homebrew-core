class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "f21350efdcc763e23bffd4ded9bbf822e630c15ece6b0697e2fcb42737c08c2d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9afa961306add0f586c2d0a8f7fdb106704f5d0740dbb80dd24b2d245f28e2e2"
    sha256 cellar: :any,                 big_sur:       "1cc6b764d5d13921f376ea00cff29f4a4297901c37a3d326f891c228591e34bb"
    sha256 cellar: :any,                 catalina:      "6b1abfafe8c2b939c78ac6287cede0aea2f1f9b3d37cf49c5757000db9725f5f"
    sha256 cellar: :any,                 mojave:        "8f1a0b551c407e1c4233a855fc674d1d0cc2e13c5ac04a0a7a8fac11533a4890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164fbaef510a74c19292362b870cb4d036868d35ad3f773074057ab56748427b"
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
