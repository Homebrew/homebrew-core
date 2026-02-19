class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://imath.readthedocs.io/en/latest/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "b4275d83fb95521510e389b8d13af10298ed5bed1c8e13efd961d91b1105e462"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce46ad834b2daf8d6e85f8f2ffa5ee5bb0ef241d8f55effedf54bba69e8a6437"
    sha256 cellar: :any,                 arm64_sequoia: "473751d9832776b48e077e901e51d68bc141f3b53f84d47ea92ea78acab812d2"
    sha256 cellar: :any,                 arm64_sonoma:  "695ca118bef6d41442b21fe26c5f26dd22be274dc6a914b535e37b93907f9dc2"
    sha256 cellar: :any,                 sonoma:        "72a4653f1f1b9e820fcb53cd85720264dd29d9de6346d97a600d8177799020af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be13320613472344b92cb55712581bdd059a5137d4f3edd60781b5d99946de95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66774757b29808a5fde422b5ddb395c14419f9e8d10bab44897777734fd52d26"
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
