class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.1.12.tar.gz"
  sha256 "8a1bc258f3149b5729c2f4f8ffd337c0e57f09096e4ba9784329f40c4a9035da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "946c5c0541452ef3285cc49eb495c476b083203d3c0edab493045cb2e665fd31"
    sha256 cellar: :any,                 arm64_sonoma:   "787f2525c5b53bb1153e265774555f2a39c350bf927ce32fdb675987db179776"
    sha256 cellar: :any,                 arm64_ventura:  "b8fb4298477012d3e5b2572264a10220370e2849214df677519f92c93a522e42"
    sha256 cellar: :any,                 arm64_monterey: "c20229d09bc63f5f7c83ba3cfa9b591993d5b08aa5a82ee1e715cffd169d42c1"
    sha256 cellar: :any,                 sonoma:         "6f6d2633c7443723f64753ceac0bd2d69c5954f615fb9d843944f03fc6a9cf32"
    sha256 cellar: :any,                 ventura:        "93b1c78e9e628d1c6897d738ec717e50b1451f84ef5a97d3109d7ba26dc42bc9"
    sha256 cellar: :any,                 monterey:       "b83b7496444abd2a7d69c208f77aa788ce65326cb9b34561a1cd467083104e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd454621cf393aee0d5448b8ac4e6e1d6cd3fd0ee88b4596be0fec333d11130"
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
