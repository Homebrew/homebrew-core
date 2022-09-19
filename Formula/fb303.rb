class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.09.19.00.tar.gz"
  sha256 "5b7e77c2df6e04a639ec4b9993dfe620a0ed3f339aa822ba5a092963d4d4b229"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5a3ec4e5d45d21872df53deee048a442279915fc539934f1bef4666cd91f6098"
    sha256 cellar: :any,                 arm64_big_sur:  "b94d1f3746a183730187163036f39ad5faff4b33d642960e2b31f879018d1900"
    sha256 cellar: :any,                 monterey:       "a2e0cb5b6ac38349880c8f333cc4e3928a324ef41dd4ec8d263f8857f271683b"
    sha256 cellar: :any,                 big_sur:        "6dc19f3778da2287fa1fd0386fa2dd643c2824a43c9923eaf2200ca6d8fe8b50"
    sha256 cellar: :any,                 catalina:       "1f350c8202a97ecc929c3d6f1c7e8664b551e41d6b6f66ad3d61f42825a3668b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "646dc4804cf9bac0a9c0d710961971519d69e60d71e6d3e5451bbc5fbac5dbed"
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
