class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.03.21.00.tar.gz"
  sha256 "23435e0af42bcfe4e244492b627e8cb30cf2d1e9dd8a7f891b947430b50ccd60"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8341600bc68b1f1e38db00464b1f4d55ff2028549228053c6c1291cd654073eb"
    sha256 cellar: :any,                 arm64_big_sur:  "d1008100351c32c74fad2c986fba475d91075783a0fba55200c208631e154980"
    sha256 cellar: :any,                 monterey:       "5fa40a3a361005553b5bb26ba69fd70c7df35b8ccac079abf254bdaa27b125ee"
    sha256 cellar: :any,                 big_sur:        "a457f971693f3f7975607061fafd85a54f6021829b0151a9b262fb7cbf8b9fbf"
    sha256 cellar: :any,                 catalina:       "f5e50bbf84584589109a99b427ca1dfa13a1d79a99030113cdc755b94ff2f74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63f16b5bdddfc7435d8c29c50fd83f39cbd70afcfff27cceabd81187f29604d"
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
