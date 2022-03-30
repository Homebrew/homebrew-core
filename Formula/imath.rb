class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "1e9c7c94797cf7b7e61908aed1f80a331088cc7d8873318f70376e4aed5f25fb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a062f442cb1477e1191f7c8bc5c679dd58add7b49dee162e1c7aaa84ee2fc0de"
    sha256 cellar: :any,                 arm64_big_sur:  "990f0df58bc099fee22bc9fbe53e5384e8f5c347840ce59b6c67c50858ca6a8b"
    sha256 cellar: :any,                 monterey:       "f76322bb6521326e7931313779021735b64d4964e32db9ac645ecbb567b74f8a"
    sha256 cellar: :any,                 big_sur:        "9415df9168a38e49695164c6469baf4942a54e88da0d001757d0fc9f55aed9ea"
    sha256 cellar: :any,                 catalina:       "9c18609d792b0969753cfaefe7418ae37d120dff1aaad1da57dd1e2bc8bdf16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eec5fa234963e53dfbdf32d814165927323ea98d266993e754e75c7d009d314"
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
