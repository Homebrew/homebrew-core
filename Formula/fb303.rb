class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.08.22.00.tar.gz"
  sha256 "452bacdaa2819326d2e9b2a37f2309afa2e819b76df0c0d53fa4547d56d950d1"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b8e883d38ed2cb4c6d49929b555ced2676ad3a666817ce77562ffca9e8cb4795"
    sha256 cellar: :any,                 arm64_big_sur:  "31c870acf04a7a1a0a0d63903fef5783035725e6977cff9e0f2bc0223f116338"
    sha256 cellar: :any,                 monterey:       "36a5072ca79e483da92aa86a853eaae7844170519bc01504bcba6ea09ac06c1d"
    sha256 cellar: :any,                 big_sur:        "cff138413e73d1820549e9a038ce085cb9030531cc30dbc7915e9f96fa6ae713"
    sha256 cellar: :any,                 catalina:       "6580de070b79a22ebe5644b13b0cb77fa4f583e2dc728ebe5445307103fe60d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160db22b046763d3d4fe588ae7094e02c52ff2608ff9660abae44a2d013d9cac"
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
