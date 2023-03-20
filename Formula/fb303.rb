class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.03.13.00.tar.gz"
  sha256 "3620828e3623ba16ec5dad93d7367719927d978268ba8fd979a865f29351c732"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7557f9551bae63e300fef47925066f79a57d9ae78526561dded7cc411f08bdb3"
    sha256 cellar: :any,                 arm64_monterey: "4108637a89ec5dfe2c95fa72f6fc98294a29d4865f4005b56bd5154e37ed344d"
    sha256 cellar: :any,                 arm64_big_sur:  "034d8eec3d24b621d4d941ccc2a31197c3088a195f72b14fbc3bb23c19673d04"
    sha256 cellar: :any,                 ventura:        "788dea4d7fee7856866ef997529fd578fc1a4afbf18b3c0f06dabbc1ac7ddfbf"
    sha256 cellar: :any,                 monterey:       "dab982e8a5433d6843acae66c0c137aaf47a2e60ab42270377cbf3f3d8593e54"
    sha256 cellar: :any,                 big_sur:        "991c6932ebb288160e178e565e48860764a6d146014e832dc6d785d0a66ac644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3941df9f7016d8ea0b85340adc3cd91fa751c0c3917a3b731774dee54b19a2"
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
