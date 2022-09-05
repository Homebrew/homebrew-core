class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.09.05.00.tar.gz"
  sha256 "59fa35558500f7de152b8c353c1466ebe01d5b5008619c17097051b7362e3e2d"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d72101eba60bd12f717d3a315c14559efb63bd928fc5c0d89564cc004b29258"
    sha256 cellar: :any,                 arm64_big_sur:  "ffc3f8cef6410fe688ee50d3921daa02cf78afb80231c0cd675c0fbe1713775d"
    sha256 cellar: :any,                 monterey:       "d0179374581a3f162a005ab7ac691db73c3df34e0464f1cb3501083814eb4781"
    sha256 cellar: :any,                 big_sur:        "f7c237a5b11959783f5f28a06bc986d4d4cf4e5bd0cd6a98604e6acac0da2982"
    sha256 cellar: :any,                 catalina:       "d0a1fa1713f251748b8f871a7491cfdb4129f61c6c62d3fee32eea90a1dfcff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "212f3486036b3951baf294e04274d0e3a812f2409c2f3896dd2b2eef7059bdb6"
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
