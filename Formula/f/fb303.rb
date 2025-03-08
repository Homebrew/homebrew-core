class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.03.03.00.tar.gz"
  sha256 "663caa3bba3b3d0351457f0967f3132d8ebdcd5bbca27a4c0a727b1b3713f9a9"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "f6991155b676f54346547d957e3b2bd21452506395d9600be9d37d27d3643225"
    sha256                               arm64_sonoma:  "077d203d66914e2b6b2b35c5e9b7b1fb898970880d0e45957564cd17b416c278"
    sha256                               arm64_ventura: "b5f801a37188823dbb04073e23b28574a7ab2b41ed526162a3db07d144a203f9"
    sha256 cellar: :any,                 sonoma:        "f69d9c89a760fa0183abc6b997ad7f058bb8ad3550ef85f86d1858e05b4e22d5"
    sha256 cellar: :any,                 ventura:       "0bc465637491dff2b0fa3a273a166bbd320d5727a5374f8113e604a5f499d66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "956e9ee5da41afd5a602f99bce7b0b126e4bd3456f6d6a4788039852fff036ba"
  end

  depends_on "cmake" => :build
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
