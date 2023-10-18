class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.9.tar.gz"
  sha256 "f1d8aacd46afed958babfced3190d2d3c8209b66da451f556abd6da94c165cf3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b40261eb35b6bea2e60626a6cc57e22fe3ef8631d59a238761ee5e3c4ae8e545"
    sha256 cellar: :any,                 arm64_ventura:  "089d0a19694cd8bb2687be2d573e9f5aa1ee75f9173033bfc0aa2c4879d69e49"
    sha256 cellar: :any,                 arm64_monterey: "cd78bb2314109596f4dfd8d30c8ddc2c93ece0605762e42ef1d610b0f99fd4d5"
    sha256 cellar: :any,                 arm64_big_sur:  "8beb6dbb10be5ff784de51ea573d7b6c5617d1474b2c018a8fc41af624a5f419"
    sha256 cellar: :any,                 sonoma:         "75ddf0a1eb9650bc83c3270ce96ac1e73175ec3a97b75281bd280ede36a9e1fe"
    sha256 cellar: :any,                 ventura:        "4cf74522f152f13e85353c2c4af9ba195fb7f75fe9fd1f4fcba590d544bb35ac"
    sha256 cellar: :any,                 monterey:       "fe2514670ff94bb4e331ee2d79fc63c87072daedcc3a0dd53dfeec3f870aa170"
    sha256 cellar: :any,                 big_sur:        "4b20276f002c8cf184c4c2ad8d1eb78ee5933e9429424321e2002e583ba25fed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64f31ec84b72c1343a1386abf63ab91c6ed7fca57304e9463dade8dd469ea072"
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
