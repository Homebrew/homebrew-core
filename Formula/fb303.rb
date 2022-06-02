class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.06.27.00.tar.gz"
  sha256 "fe9411dc4285fd23d2b59c48737eeed1aed8294b2106c0cc2f11168803ef9022"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83d25761dc3e596a734fb39d77fe58becbce8fb472aaf3bc43bb7f1ed9274d16"
    sha256 cellar: :any,                 arm64_big_sur:  "4595de91cab9eac33787fa3122b490bf8a90569a7064f1272a98aedd9361e1f6"
    sha256 cellar: :any,                 monterey:       "b66b756833e67d3e0f64ab945d9047d51dce0b9307d5924698f6bb8bd7dd597d"
    sha256 cellar: :any,                 big_sur:        "b692e1796f3b81d82f19ceb5caa9409e6d61b30376006f99043417a734ba2061"
    sha256 cellar: :any,                 catalina:       "41bcdec5cefd5240779cea5c87d1748de73504fe8c12ec9723047b69698d768b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ededd2bd9233d250d85d4d193e1aa986307df49e48796e17225799ae9c0ef4d"
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
