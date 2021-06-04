class Parallelstl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/intel/parallelstl"
  url "https://github.com/intel/parallelstl/archive/20201111.tar.gz"
  sha256 "c5ca7e0a618df8d28087be2e23ae38713ab1bcff0107562b935fbb5ba072fbf6"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3467deb5b4e2b46b8ecdaa4930c6e01ae4f432b01648e04912ff2bd8d9737e4b"
  end

  depends_on "cmake" => :build
  depends_on "tbb@2020"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    prefix.install "stdlib"
  end

  test do
    tbb = Formula["tbb@2020"]

    (testpath/"test.cpp").write <<~EOS
      #include <pstl/execution>
      #include <pstl/algorithm>
      #include <array>
      #include <assert.h>

      int main() {
        std::array<int, 10> arr {{5,2,3,1,4,9,7,0,8,6}};
        std::sort(std::execution::par_unseq, arr.begin(), arr.end());
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
