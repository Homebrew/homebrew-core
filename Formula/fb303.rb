class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.06.20.00.tar.gz"
  sha256 "a3561271e0b209a378039db69e1608717b1c22e90ab0686c18d630ce35fedbc0"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d5119434d9009b3299b8d0498a68a7e45d9657faef9c8bb7f127cbc596795db"
    sha256 cellar: :any,                 arm64_big_sur:  "32f5119cebe4de47d3b387878183ac099db5945d87c79e40501454df81ab114e"
    sha256 cellar: :any,                 monterey:       "00fe5737aff75e8e017332c9fc7138818241cc2a9d49cd5102ccf0461855ca8e"
    sha256 cellar: :any,                 big_sur:        "c1844826f4a35f3036b44112bc815db31d95cfae422ed414d28716039617ed80"
    sha256 cellar: :any,                 catalina:       "331ed74c0fb712cb3fefd74ad89d241e234229b7d4018537b62eaf678ff5dd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f61559311dca08a2cab833fb44c84a7d4c26a3347d43b27c63906d9cff6ea0b0"
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
