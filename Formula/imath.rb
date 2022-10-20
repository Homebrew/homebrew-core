class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "1e9c7c94797cf7b7e61908aed1f80a331088cc7d8873318f70376e4aed5f25fb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9a1333aef15ce338d27e3cf73885750c1dadd7cf0a664cf6cd887a841e95c9b"
    sha256 cellar: :any,                 arm64_big_sur:  "1e8b8cef1b3fee6809cac3d9e73182d1218044960e3295411e6b8c68d3601d42"
    sha256 cellar: :any,                 monterey:       "60265951d4debb77e090194e08369ace9957411da8d94efd1ec16487b42cbf1b"
    sha256 cellar: :any,                 big_sur:        "5acea94faccfa4fd8ca1964bce545d751d9404c6e6830a0d9a75031a529cc06f"
    sha256 cellar: :any,                 catalina:       "cbbb632a0b17f931262850308af109b1ccb9dd533a861069d4de1edb092ae00e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62d672df3af0e944fcc190526981aede2b48c65c65de7b602a5b55cd882602f3"
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
