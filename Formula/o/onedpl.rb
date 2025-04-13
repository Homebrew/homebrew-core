class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/oneapi-src/oneDPL"
  url "https://github.com/oneapi-src/oneDPL/archive/refs/tags/oneDPL-2022.8.0-release.tar.gz"
  sha256 "d500007e64efb778a72d34f25508db5b8e0f596eb2ec58f4c9211f9b461ef70b"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac492d8a27791d6d828725a273b0473275bfc32ea4f9fc56406b9f171d049144"
  end

  depends_on "cmake" => :build
  depends_on "tbb"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    # `cmake --build build` is for tests
    system "cmake", "--install", "build"
  end

  test do
    tbb = Formula["tbb"]

    (testpath/"test.cpp").write <<~CPP
      #include <oneapi/dpl/execution>
      #include <oneapi/dpl/algorithm>
      #include <array>
      #include <assert.h>

      int main() {
        std::array<int, 10> arr {{5,2,3,1,4,9,7,0,8,6}};
        dpl::sort(dpl::execution::par_unseq, arr.begin(), arr.end());
        for(int i=0; i<10; i++)
          assert(i==arr.at(i));
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{tbb.opt_lib}", "-ltbb", "-I#{tbb.opt_include}",
                    "-I#{prefix}/stdlib", "-I#{include}", "-o", "test"
    system "./test"
  end
end
