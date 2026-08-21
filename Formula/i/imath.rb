class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://imath.readthedocs.io/en/latest/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "e10c12b3f21f45bf08e09d4215d9c7691368d747beebd840de0b6fefed2df9f8"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cd0092341705d6b55ef5e9cf76ef8d5b079af1e4bb3a0d403ae0f308e9775e19"
    sha256 cellar: :any, arm64_sequoia: "4f6c05dd778e795b70d60af8daacc72dfa4b92ecbaece682ad98c36df92be150"
    sha256 cellar: :any, arm64_sonoma:  "565d60cf2da053d45fc30d4eb9cb3d0e5da4c8c7bb4dead8c402f3a1d518cc1b"
    sha256 cellar: :any, sonoma:        "1004b5307a29739dacfcc9118478166ced4ff91476e573b22f9cbd1343af9ee7"
    sha256 cellar: :any, arm64_linux:   "0a14f495df426cce6b9a7e6595937377123951ee327b0ddc0bc75fd2c489b445"
    sha256 cellar: :any, x86_64_linux:  "3664b41b9a85c26b5735f4a3507f0970e83d4ed53cacb62c7ec2cc36a3e2c74c"
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
    (testpath/"test.cpp").write <<~'CPP'
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
    CPP
    system ENV.cxx, "-std=c++11", "-I#{include}/Imath", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
