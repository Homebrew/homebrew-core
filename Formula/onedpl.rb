class Onedpl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://software.intel.com/content/www/us/en/develop/tools/oneapi/components/dpc-library.html"
  url "https://github.com/oneapi-src/oneDPL/archive/refs/tags/oneDPL-2021.5.0-release.tar.gz"
  sha256 "b79237ff55b74d4758c481d6262bb367483dbdb21185dab53accb63f307525bc"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^oneDPL[._-](\d+(?:\.\d+)+)(?:[._-]release)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7130aaba10f1f733e4cac0c799662b4eaefeceb486c5b062d2055dc595d41306"
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
    system ENV.cxx, "-std=c++11", "-L#{tbb.opt_lib}", "-ltbb", "-I#{tbb.opt_include}",
                    "-I#{prefix}/stdlib", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
