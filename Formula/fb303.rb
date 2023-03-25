class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.03.20.00.tar.gz"
  sha256 "9ad48fa45b2c4b9779ae1b6fafc323b21840f670a930e3135db1c5107735d8eb"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "49257fab0ccf37202608a1da071e109853289a9149ef3d823210698cdd520bb5"
    sha256 cellar: :any,                 arm64_monterey: "3d50ea0c0ae0733e860679149892c826fbf70af242c35a27bab4187ddd3bca6d"
    sha256 cellar: :any,                 arm64_big_sur:  "b352d17e8c8b550b91ec88003f3e6a2653e2565e2d8f576d656f7b7749d1c095"
    sha256 cellar: :any,                 ventura:        "b9eb55200abb2cfe56e147cb0f2d076be3e9a234a08b80b57edc7fc17e920e4a"
    sha256 cellar: :any,                 monterey:       "fec1fb9f8abb91cd23c0379617520d6b662529703f9cd6f8a6c2b4533a2dec1f"
    sha256 cellar: :any,                 big_sur:        "fce3a03ed29b02a9852738f35f03930c3e23f71fd35e418bb506ef9f7a8469bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a269bcc314a03ec3b137c407e040b12f0c2bc459023366ba6fe03ae5c3f5d3"
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
