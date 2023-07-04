class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.07.03.00.tar.gz"
  sha256 "5800cae11cd4edfa79c4f14a6e7056a717b70d02c7e41f5eea75bb9ed58e2f54"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae0630fefec5210eb7b639da0e6e1de9ce6cf081b93c7757843be6890a0bcf93"
    sha256 cellar: :any,                 arm64_monterey: "d83f3633775a2f8e11de80011fe63e2d491420d5b62958c045e69a59327164e3"
    sha256 cellar: :any,                 arm64_big_sur:  "caec9032262732e7c53d77c6d3095894b90a1ef18782546cf4d182b8338b1383"
    sha256 cellar: :any,                 ventura:        "000aec366ab48fc7d9f8e81133400cbbf798c0cf25e2bc6f0d3a5b00e97dc6a0"
    sha256 cellar: :any,                 monterey:       "7a807755b1bec5c70224b21b2a517064c36f73ec2714a32db2655a7d0db42721"
    sha256 cellar: :any,                 big_sur:        "4aed6ee63de5681e1fd8c6dceb9a30ac69b7603aa7f9f2fb4be44bbc5f802600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1bba0e159f62423616c680a597dee3305d0c1c593b67e52a36676a0a967961b"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"
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
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
