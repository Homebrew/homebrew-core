class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.0.4.tar.gz"
  sha256 "3b5cef518964755963550b5f4a16e7c0a0872574921b1443f1d47fdb6b8c5afe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d566baed11c63ab4a459fae705f97886ad32a3e568b54c323dd56ba27aef258a"
    sha256 cellar: :any, big_sur:       "b959374888c1cc36b4133da024076bffa52ffdf9c9832ce16abf5201fd0ee568"
    sha256 cellar: :any, catalina:      "aec5a5567cfa9df3ae811b55d7fd987d4cdee8e6c4cf13c42e2858dad1815242"
    sha256 cellar: :any, mojave:        "b0364f416a66f09f4908ec029a5c1ef2bb1f3bbb0a2c463bccffe349568756a6"
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
