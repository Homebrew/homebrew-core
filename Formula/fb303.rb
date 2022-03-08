class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.03.07.00.tar.gz"
  sha256 "ad62e462a9866e328e2ea80a4e1dfdf969df9d5f2088969a40fbc5a0029a6486"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e8014cde099f40b8e94c00d40cf7f710f75eeee736adda6096e7a0b7dab3ac0"
    sha256 cellar: :any,                 arm64_big_sur:  "c65d40809e1edb96ded0801239134d0216a59b45788c4c0a17c74056d4e78137"
    sha256 cellar: :any,                 monterey:       "2c4822f8ff63a04f53de9219e1663b0047dc281097b34bc456458e222d08b1c9"
    sha256 cellar: :any,                 big_sur:        "198705313dd4403402391f53db611ede61d31461349f7870b21bfc6b153aa9bf"
    sha256 cellar: :any,                 catalina:       "ded3bdb827062884410d200308882a4d7a2d296c7d49c645590076919188414d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34500db1883dcd32ca2a5184cbb9fe9e50075902deb80b2482551a52c50eaf1b"
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
