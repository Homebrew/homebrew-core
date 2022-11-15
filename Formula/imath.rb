class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.6.tar.gz"
  sha256 "ea5592230f5ab917bea3ceab266cf38eb4aa4a523078d46eac0f5a89c52304db"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b0165f1503e0230d80cee448635ddb08e376d62069b9b426f5e363bb5cc8ba6"
    sha256 cellar: :any,                 arm64_monterey: "ff6169b5986b709c9febe2b09929abc388a188be8041390a95d3f7b6f5814a22"
    sha256 cellar: :any,                 arm64_big_sur:  "a94b22dd11a845ba003521ad6f80f4c2195059dd760047a07a802fd59d308f1b"
    sha256 cellar: :any,                 ventura:        "66b235ef04409e3cdb50d419b32fba3e16680aa11211d8b0135393e5b9e609b4"
    sha256 cellar: :any,                 monterey:       "9afc755be66e72fea866b8563934e704bc63ac831cca3b0e3661beb47fdb52ef"
    sha256 cellar: :any,                 big_sur:        "1414bb873ce5225aca9173aaf8f4f74dea587c2077d4c934f36ac1e6cdf884f1"
    sha256 cellar: :any,                 catalina:       "26b26215e534e8ae8a6ed2c95b04e0706932ef4aac9aef4a84396433c068d11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f528de89730addebee49712701b2ee345b3ca8166b0e0f926a594652fdc85bfb"
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
