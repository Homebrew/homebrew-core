class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.04.07.00.tar.gz"
  sha256 "c5faebce8c0013ae4265558fdda7672e1f6d216cee2874aa8868915529d3d72b"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "35c2713e027b6e6a2d4d10218e739120f1d52f6e528ebf8d0053256449f33d32"
    sha256                               arm64_sonoma:  "53250060240fd3d28dcf228286cad5affc819e5e81a1e80fc0723c1eab0d9ca3"
    sha256                               arm64_ventura: "92fbb2ac91abc2876adf7b9a0943271c82c402b5ce1af6750d7706bca1b9bf32"
    sha256 cellar: :any,                 sonoma:        "22d3ce83514742267d892a86f53ec28ab0f14b9500fd31a4d8c095e93a4d4797"
    sha256 cellar: :any,                 ventura:       "3236b5ab0f67673799a21a951f6d636fa363308034f0f624ae65776f1a8cfb46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d03e3acc09448ee516ddaeef40af42a40f32002e7d6f77dc64c75dfc74d5493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487f6163b83a8149254f3c563e50d5011acbb7b66dcfa1ca75db3408f1270a50"
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
