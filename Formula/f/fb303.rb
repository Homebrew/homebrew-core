class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.10.07.00.tar.gz"
  sha256 "dcd9b86b9326324a572ac31eda6aca63c5976b21095f2733832adb314e1b7085"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74fc74a3ce4f0b4e8bd93108529beb1cd4f364477ce629a66210eacc8301a49a"
    sha256 cellar: :any,                 arm64_sonoma:  "726cb796802db922e9813f7cac4c5c0ea0817b926db5fbbe6fdf00ff3fb400f3"
    sha256 cellar: :any,                 arm64_ventura: "21807ff31dcbcc6ac9516456853f92a0951298b6a9bbf00aa1df2c7d3abecb32"
    sha256 cellar: :any,                 sonoma:        "3772d4926622179f712cf4adf4fc9eabecca0d20f0aabd1a0ee485c5ac85597f"
    sha256 cellar: :any,                 ventura:       "91145fee399b928a1cf7ba92a2f5d92e3f929117ba112927349f40a700fdcfec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21745dbf6545edf4debd0c2345aeb133769f485869a533bbbcdeded2192b02e5"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
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
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
