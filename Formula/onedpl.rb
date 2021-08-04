class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/dpc-library.html"
  url "https://github.com/oneapi-src/oneDPL/archive/refs/tags/oneDPL-2021.4.0-release.tar.gz"
  sha256 "74ffc0fabd6a74af8c1a7a92f049794559bbe5afcd755398f1b130226f1b60fa"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c09dcadf4308512478900387b6cb785cf95af41aaa280487341120d765a1842"
  end

  depends_on "cmake" => :build

  depends_on "tbb"

  # CMake: add install instructions
  patch do
    url "https://github.com/oneapi-src/oneDPL/commit/008dd241e4766bda87e439ebe64a0f91d795b181.patch?full_index=1"
    sha256 "a7e588130b3016a609082b95352a716267ea49c316b7cf1977d010b241fcc0ef"
  end

  def install
    cmake_args = std_cmake_args + %w[
      -S .
      -B build
    ]

    system "cmake", *cmake_args
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
    system ENV.cxx, "-std=c++11", "-L#{tbb.opt_lib}", "-ltbb", "-I#{tbb.opt_include}",
                    "-I#{prefix}/stdlib", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
