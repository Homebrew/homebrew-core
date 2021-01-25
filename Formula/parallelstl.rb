class Parallelstl < Formula
  desc "C++ standard library algorithms with support for execution policies"
  homepage "https://github.com/intel/parallelstl"
  url "https://github.com/intel/parallelstl/archive/20201111.tar.gz"
  sha256 "c5ca7e0a618df8d28087be2e23ae38713ab1bcff0107562b935fbb5ba072fbf6"
  # Apache License Version 2.0 with LLVM exceptions
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5f7b936a95bd0c34f5dac2deb1d642fdaaaca6a5fef2fa72879a82ceb4e3f84" => :big_sur
    sha256 "944b95b0b94389d981d71def6dd11e676c911c578b680b08c5a176937877a5ac" => :arm64_big_sur
    sha256 "90737db9c682cbb31c250745bf089fd4f3d72fca3980dad138472c1d6ef8a5ae" => :catalina
    sha256 "c0eb967346b81fa899a348dcc51c5cec898add7384134006bf2335f349b9be4a" => :mojave
    sha256 "4e0f682ecd6e591ab1a6d71e4579409485a1a63bbcc1b6d22738eda43e1fd762" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "tbb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    prefix.install "stdlib"
  end

  test do
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
    system ENV.cxx, "-std=c++11", "-L#{Formula["tbb"].opt_lib}", "-ltbb",
                    "-I#{prefix}/stdlib", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
