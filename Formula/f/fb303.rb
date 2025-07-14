class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.06.30.00.tar.gz"
  sha256 "b8c4d8593d0fe450f2d590d9a4296cdc425bb9150328d804b1bacf27817cd572"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "081274c930e4ea6133291cc80cb88c2f89d4a3d9efd5959a817c77215b1b14a9"
    sha256                               arm64_sonoma:  "7f3c8f9e17c1047ce2cf10042a3a81413b4568ffb712ed207c9476614be6bace"
    sha256                               arm64_ventura: "ad548835df76319e3bb959f8b720870e92796f5be91d65280a3472790f036093"
    sha256 cellar: :any,                 sonoma:        "43d3d1dc5e30ec022b342f68d738fc6eb911dcb2b4bc4102cc93502043483170"
    sha256 cellar: :any,                 ventura:       "8ce6bc87a9c940051d224626590ff22ea60bed621dcf75c337fb5aa2f1def4be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28ddb0f8eece830d98a9a75a516ced90c8c2a6ef7c7d8c9abb39b693b7d975b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140dee79756d0268502f5c986f841d1f80b777576a331d04e0856669115c8813"
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
