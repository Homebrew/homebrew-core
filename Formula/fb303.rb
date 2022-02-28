class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.02.28.00.tar.gz"
  sha256 "171c34c52996638b5c501fa72aab9a3bbb1046eb811dd3ef8ca33c4c326a6369"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "420525bd66f6ccdd5135238ecdb7a9eb4b684967cbffa08665284e149aaed490"
    sha256 cellar: :any,                 arm64_big_sur:  "af69bd7d4b0bf48b60f33e403d1809c96c48189c9a31e5df2dbe31c78ad7591e"
    sha256 cellar: :any,                 monterey:       "89280762748f5ce1f44a7530d90ab4838c913028ef97d64dc78a8b168e8ea8b4"
    sha256 cellar: :any,                 big_sur:        "fc67f37360ddf321096e79b3a801d35604643a29cb67656c76437a70578ba504"
    sha256 cellar: :any,                 catalina:       "5730ed4e9eddf86255e80feb3a59ec96e18e0b012ffcda07e2cb38c2f6b9c182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "314652adbbba82c288707fb79e2f4989304ad99b2f177814a5156b96663e2013"
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
