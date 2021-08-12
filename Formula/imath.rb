class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "f21350efdcc763e23bffd4ded9bbf822e630c15ece6b0697e2fcb42737c08c2d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "37631ebf8b101e67a10dc66e09209d1cc391d67b5d78025113eddbc203f48ddc"
    sha256 cellar: :any,                 big_sur:       "342050b4bc182b25d0db8b4044b874f86408bfa8e6c386e3bdd02a54312e1a5f"
    sha256 cellar: :any,                 catalina:      "36960bb3e2d521dbd404109e20a65a45098a017bdc8b49ed414d969239f6222f"
    sha256 cellar: :any,                 mojave:        "749f788cc8ab12727ddf29d3dd2310edcc5bb517477fc8ae7d8dbc60388b38ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94659650eacc2380ab8e8142fe1958e111dde4e69492c6d47afaee3fe2a97cf5"
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
