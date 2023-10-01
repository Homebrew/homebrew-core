class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.09.18.00.tar.gz"
  sha256 "184c7308b771d6998848b8741355c0cfcd970713eaeeaa856e77faa1de9ea243"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ea8236c38e35ef19d722b80fed1f3b018748ad727f4c09c0622dd51be50e266"
    sha256 cellar: :any,                 arm64_monterey: "c483ef0a5f91f184e5360c7cf7b0906d721c36bcb93395a357c96baebe62b1c9"
    sha256 cellar: :any,                 arm64_big_sur:  "87779d2b3b0c98e57c247e48990a4e12cd7dbf0979d8265dc1df89ebe2da2a2e"
    sha256 cellar: :any,                 ventura:        "147c9b09222548b78860f6b6908df05b36d39b9c3ddbbd905017cc0b18525d0d"
    sha256 cellar: :any,                 monterey:       "8b5f11a2e84b97d7ba2f87698fc5e9ef8e794a547741b454b79c85051da90924"
    sha256 cellar: :any,                 big_sur:        "b1a6248bbc3525e0a0835ed2c915d92ca4682224728390751fac168211950b64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d74bea76be08c4217b658bd917c978bd6f2f586b39fd0ab5739e003c7a39346"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
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
