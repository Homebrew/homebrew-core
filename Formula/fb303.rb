class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.06.20.00.tar.gz"
  sha256 "a3561271e0b209a378039db69e1608717b1c22e90ab0686c18d630ce35fedbc0"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cbadadfde8980abda38f8748b2c9a4b0d6961b7a0a779c21c408117077073bff"
    sha256 cellar: :any,                 arm64_big_sur:  "3a4f3de1ad078fcd9d24a17d123abb5aa716755f8a04f86daf5c8ed9dc7303eb"
    sha256 cellar: :any,                 monterey:       "3baf6a45186963f27ec1b06350b4d4a6abad10a03bc31024f26919fb00fcd62e"
    sha256 cellar: :any,                 big_sur:        "7fd5287f039a97fff3e97f64dd94c2a9edc59373ab9abd53ad455ad185ca47bc"
    sha256 cellar: :any,                 catalina:       "eb143f8933f192531f57702822ea600b50cbfe799790f1d3472c3114ee94b308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa6784f01808a4268410bb8018c83c091509c647c961e29e241fd42438f1553a"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}", "test.cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly", "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{lib}", "-lfb303_thrift_cpp", "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl", "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-o", "test"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
