class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.04.17.00.tar.gz"
  sha256 "b3b4d3bfc63173b8417b053685ef4822e279db91f565812cdf084a0b0d3da98d"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0bc1fb81e9398efe3da8b9f6dd6cb636ed701688be7cc33b104b1fe59380bd88"
    sha256 cellar: :any,                 arm64_monterey: "2b0be1d40170e2d6913bd2a716dce66238277683e8c27bf1ad7fdb52e33a6be2"
    sha256 cellar: :any,                 arm64_big_sur:  "3064393029421bf7989fb8799bec091ad7a313675d47901206b27346d3ff470b"
    sha256 cellar: :any,                 ventura:        "9598518089a6e624014e2e3aab0dfbd56678cccf4b54eb55af50e90d13975dd8"
    sha256 cellar: :any,                 monterey:       "69c00e7dc29270ff26de2ea18137b7c56baed87d53e488552d8c32041ca9f9d6"
    sha256 cellar: :any,                 big_sur:        "fdae5c8f5f7de8206b8bcf8c3b067951b3617fcd66234351006567ab76b0982c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8efe63a465703e7abb3f70ac36da8610200a492b2af562da1d151a12739874b7"
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
