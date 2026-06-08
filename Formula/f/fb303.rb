class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2026.06.01.00.tar.gz"
  sha256 "3e9e00b7fc5768571d8e426f57b911f62c5a65f4d6a969d1541c53632660b59b"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "76def15e9fcbce65f0a4508d534d2a1927d574e9725d6ae9db211bdfbd3a2a27"
    sha256               arm64_sequoia: "8119fc16357c005a08ae0a21a71dfe0c2e5a4a4fda6a24e300b9c5e90d885c92"
    sha256               arm64_sonoma:  "4a01df0b6d631570c9300d77a73e97ccb3b1422777011de487602e9e80a7075b"
    sha256 cellar: :any, sonoma:        "40613f0827daecb27121e3e87047ed6032bf19a679302296f1f9b807f03476a2"
    sha256 cellar: :any, arm64_linux:   "fa7934b33317d5e7e3adcc6f88b2b6c2ede0570679451a550a4685dee1120371"
    sha256 cellar: :any, x86_64_linux:  "725cdb392a85ce24a596bf81dc6de17178e01313930ecf30deb60c485c636933"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "fizz" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

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

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{Formula["fbthrift"].opt_libexec}/cmake")
      find_package(FBThrift CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)
      find_package(fb303 CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fb303::fb303_thrift_cpp)
    CMAKE

    ENV.delete "CPATH" if OS.mac?
    if Tab.for_formula(Formula["folly"]).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"]
    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    assert_equal "BaseService", shell_output("./test").strip
  end
end
