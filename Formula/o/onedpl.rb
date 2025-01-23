class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/oneapi-src/oneDPL"
  url "https://github.com/oneapi-src/oneDPL/archive/refs/tags/oneDPL-2022.7.1-release.tar.gz"
  sha256 "0e6a1bee7a4f4375091c98b0b5290edf3178bb810384e0e106bf96c03649a754"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91836cae67bc7b9123778574e3f9a2521f5f838bc8f89bbc789ba13c8d90d95a"
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
