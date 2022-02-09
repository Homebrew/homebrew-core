class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.02.07.00.tar.gz"
  sha256 "82724de4c5ce5667fabfa56114b7432813a2aa620faf3ae1d41ecbe1a2c1910e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c0f5029ee48feaca9f9d4282f1c7cec3bd142fba24733aa51d81ee0b6615753"
    sha256 cellar: :any,                 arm64_big_sur:  "65663a53812700c9f5602008c716410b3e26631d7ec2ff6758daf756cc533b95"
    sha256 cellar: :any,                 monterey:       "6ca06943de14f14ebde858742a83425ab55537e794bdd138f2ddf6204ced6a16"
    sha256 cellar: :any,                 big_sur:        "bba632690bd824e9203e992fac73e46b40fdc5c5ad75f6d9397aa746f1c141b3"
    sha256 cellar: :any,                 catalina:       "d61c40fea9d34f587a97bd57a14d7560739fcb25230bc7ec6c9e9ead3c73dc9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2354a88d937811c12ea03d76dcc160ed1943c0b7b1125e2b9a275421e56e54c7"
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
