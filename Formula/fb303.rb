class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.05.08.00.tar.gz"
  sha256 "81b818e69c580cd88e4e3085811e3a4d68612c5b83c6f4ef0f73024d3b4a38e6"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fd11bcb81f9ff4709888e8f1fa13cece32c11094ecce918df4f552f7f90169e9"
    sha256 cellar: :any,                 arm64_monterey: "49bbf88163dda5bc5727f049bcc2301d588f3a1370e819b6458b0581f5ca5972"
    sha256 cellar: :any,                 arm64_big_sur:  "e28d574ca0d77852e8081a66b21d77758f5396b3f8587fcba71c700f67911920"
    sha256 cellar: :any,                 ventura:        "8ddc19c5f0e7ae1fd4042b0a918776bc9666714d848bfc5775faf4281e4fe006"
    sha256 cellar: :any,                 monterey:       "252fad3a45d916a3beb1cf9436e74cad674f122ea368d4ab896f57d0bd76e347"
    sha256 cellar: :any,                 big_sur:        "d8e05259bfc697338ffaf8ed839a229d71dd5b2365372fc8f02cd39d09d58dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b57a2ee96e0d66c6ba053274327c9251a08543a982bb5c3717c1de49c44fb830"
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

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++17"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
