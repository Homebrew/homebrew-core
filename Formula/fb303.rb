class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.05.30.00.tar.gz"
  sha256 "e93c978bde62f14486d5ecaf350b5079f15a22905d034f8b2fad34d2748f166e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "606fae198305b20179aab40c466d1d841e5a486977bd3fc7e1fecb352cf8a6cf"
    sha256 cellar: :any,                 arm64_big_sur:  "db8d9f71f6d574aae1f9a3cdbfc3041309de524f813948369a1a6b4d08928072"
    sha256 cellar: :any,                 monterey:       "d0e75c54c76fd3f3136774168d19824edfc54f9a2fff2ea0fe21916078c96aa0"
    sha256 cellar: :any,                 big_sur:        "2a0d81ee5bd4e3378243cd4a461515abd230909e78b0babc05b66c756e3485bb"
    sha256 cellar: :any,                 catalina:       "5f84f2c58205b3a68601e46d210b88ded08fd04460fabeda2482cc900653fb0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848f5399a8c4901e272ada4d7a2e70f7219d9de956bda42149081c17b832ce4e"
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
