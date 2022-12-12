class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.12.12.00.tar.gz"
  sha256 "02c6264faedfe087ab5f047344ae829ae953f68e382528073059cdb49f80e2b0"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7365947fdf8ab89e5dafc0b7015a338374221aa3f3404f4e2cd4c25f753259d"
    sha256 cellar: :any,                 arm64_monterey: "3bb74cd22287f2bf1201c05510f089fcbf9baf753f678dcffe8f9a39e0182647"
    sha256 cellar: :any,                 arm64_big_sur:  "86196d3367f575aa7faf3c63d99c7ff976b42aed3b7f786d64933a5eb548abab"
    sha256 cellar: :any,                 ventura:        "db26a4ef30f319d31721d0dabd5986f10c142b81b2c8cb0896921d93f9808724"
    sha256 cellar: :any,                 monterey:       "6a88a6f63c6151799ef5d9df6e65f7a979155365e95244806252d98f3a0bcf69"
    sha256 cellar: :any,                 big_sur:        "afb98921f6d27d88a45b850102657ba7f25591af69d5959c1a5460dd3ad88dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e02c4352fae36f4ac2307f8272b7e99a8cd74b1a600fff45f27ac7ef7edda7"
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
