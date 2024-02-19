class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.10.tar.gz"
  sha256 "f2943e86bfb694e216c60b9a169e5356f8a90f18fbd34d7b6e3450be14f60b10"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "24c57d4a0f4d44c372995a3f2e3a6648ac1d1b3fedfe40e1411b845c7a9f3ee4"
    sha256 cellar: :any,                 arm64_ventura:  "df05fa1fae871cc631d18f5bdff6c2a1658dbf40be530d5c356841f76e957898"
    sha256 cellar: :any,                 arm64_monterey: "28539e853bd2f828186318b9a03b005c9b22255efd8878757de0878810e4fd4c"
    sha256 cellar: :any,                 sonoma:         "77fa1aec2959111d75ea8179f10025bc35470fa6d254190dceb8695cc97f4e00"
    sha256 cellar: :any,                 ventura:        "56c81ff84f3be1b98ba4745de23ec639bdee8b60f727bcb09520d48aa6a613ee"
    sha256 cellar: :any,                 monterey:       "b0993ae34a3fd582708e578386d7c89ac2654db3e752ad79823764b302fcf784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbdc08902491405961995e0c99200ed3164d5d90c9d62a1a9718a912d7722c5b"
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
