class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.05.16.00.tar.gz"
  sha256 "123750d56cdb9895534ed5f5b99f6867ffdac05b7e890eb652a2f6d6f883c8ae"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62bc3052575c69b2638b5175892f8fcad4ef06281e4d8b90c2c9105670f92c6c"
    sha256 cellar: :any,                 arm64_big_sur:  "d9233f52ef98ed38b38bec978d5b99bfde04e08aca731ca53f3e251f5b89eb1b"
    sha256 cellar: :any,                 monterey:       "ba1e7523166b6669c74ad66c99ef3146680e8b27b3e5111994c5d962b50467d1"
    sha256 cellar: :any,                 big_sur:        "72600b5192d830a0c2d62ec009f1f9b42117e4076b1eb893a65beb9a5008f92f"
    sha256 cellar: :any,                 catalina:       "bce9822b5c35d50788c03cea7f12d730f9933b12cfb3484e63879db85a2c0b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88883cc9064cfffb2c259d2841c2ad3b948a2d71439bb467e9e5b45bfcb399b2"
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
