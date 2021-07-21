class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "a63fe91d8d0917acdc31b0c9344b1d7dbc74bf42de3e3ef5ec982386324b9ea4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "cc66925ade283874716038ce320487f62dac4df406b293900dc4c6f30428df11"
    sha256 cellar: :any,                 big_sur:       "172312233516d28ba50929a748586160e72d26342cb88514e7c02263d9fe654e"
    sha256 cellar: :any,                 catalina:      "eb6a5fc81c9321c6c8289ecb53b57e60271d611a8e5606ddd5e00a97af99dbab"
    sha256 cellar: :any,                 mojave:        "5dee04de8175f84e943cf957c3bcbb637ccb5a097d4199f53a89a4197395639b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f06557ba227d9f3d4556dc7d31aabce6453c06e7b6ecb7777b5d22f88be5f5f3"
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
