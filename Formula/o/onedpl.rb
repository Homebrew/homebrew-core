class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/uxlfoundation/oneDPL"
  url "https://github.com/uxlfoundation/oneDPL/archive/refs/tags/oneDPL-release-2022.14.0.tar.gz"
  sha256 "1e40549d300265aac5459e6e52b5aa5ae9073586067c4a4a38a21c3511ca0373"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18ffa11fff8224f7f04c18f2c76f5f5ca02d1b44225a9ab70d1748b7b94f1be7"
  end

  depends_on "cmake" => :build
  depends_on "tbb"

  deny_network_access!

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
