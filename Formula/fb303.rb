class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.03.07.00.tar.gz"
  sha256 "ad62e462a9866e328e2ea80a4e1dfdf969df9d5f2088969a40fbc5a0029a6486"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cf97001208d32f6a383ff0c124c92dbd22397fb59f3fd988bda876766b0abee8"
    sha256 cellar: :any,                 arm64_big_sur:  "ad84514916bf50b405db6057f69767fab57b911a03a485ea2a8f6184fa8c6b1e"
    sha256 cellar: :any,                 monterey:       "f48e4de1eba212c9625ec0aa03f857bfaedf699515df576f2d36aa17463d4d09"
    sha256 cellar: :any,                 big_sur:        "62d241c4c3d979bfd6e8674f7dff81b375ad03df129cf2e44fa480b068f9079e"
    sha256 cellar: :any,                 catalina:       "33c675cab81bf281475614c786c3cb9d85ed158ae096f978f8a0b36ef1f452e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ecccbd57ee4c1926b43fc9e57c8083e8b923007d89ac0a0be0011380cea437"
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
