class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2026.01.12.00.tar.gz"
  sha256 "e455652551702d040b9ba7c9e3991f556c851fc513fd28b039a56127a1190dd5"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "342e0512149ac41ce762f451f5345a0809b3e24b83fcb8b30837e8978d7cc431"
    sha256                               arm64_sequoia: "bd1fd7e297571c608e0155ee435d22ee2f17514f07adb7e68633f331cadf6170"
    sha256                               arm64_sonoma:  "92d0d72f2b26eb915f0e74d87868a878bed4793e7c35cfca7ff4cb42a6bae150"
    sha256 cellar: :any,                 sonoma:        "ca591f9bf14af70b415783e01bbf283fec8bcbe9abc5359d7fb99d4f92424168"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4eea8812686e19787b8824f7d7a2536c24096cc248c479f5518110551799c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7242cbadf175d2c9961144eda50f3adcafdbbb73f75b28e86b80f036b5b7948"
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
