class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.11.10.00.tar.gz"
  sha256 "4edb02ef25543fa94741f3478666fb08f18fc3e22892c6c406fd041df8315f94"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "50b065e8075225e06708ecb7d66533fb5e75bd5f770e7a2d05bdb6b60dd12279"
    sha256                               arm64_sequoia: "3c99120ae367bdd20d482e506892df273a4224e96030576025d1bc3ea242409e"
    sha256                               arm64_sonoma:  "74e7924e62c02ee572ec437cf9f6587619b6077b71913eb2fc4b4e4ac1027ccc"
    sha256 cellar: :any,                 sonoma:        "707abfb7f903fb341cebf42efbbaae44dec5c1075f6199b5df49512516cb672e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc48348057d9b8f4657d7ba42c87e00c34b66f82ca4530fee0fe81a6235a0e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc3b43bb1d89fb5c7c1e278e42535f2fde10728971cd97ca0a21c1a040e90525"
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

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append "CXXFLAGS", "-std=c++20"
    system ENV.cxx, *ENV.cxxflags.split, "test.cpp", "-o", "test",
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-lthriftmetadata", "-lthrifttyperep", "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
