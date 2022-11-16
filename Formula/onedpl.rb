class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/dpc-library.html"
  url "https://github.com/oneapi-src/oneDPL/archive/refs/tags/oneDPL-2021.7.1-release.tar.gz"
  sha256 "3f9aa5b23b459dc8cd818975f1dbb313e690f1976551ee1fe45cedb775c3ef7a"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0569d75967ca8c8d00aa51390324d2165101715669a511cc5e5234c9e3a00716"
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

    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{tbb.opt_lib}", "-ltbb", "-I#{tbb.opt_include}",
                    "-I#{prefix}/stdlib", "-I#{include}", "-o", "test"
    system "./test"
  end
end
