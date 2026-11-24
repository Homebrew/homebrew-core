class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/meta/fb303"
  url "https://github.com/meta/fb303/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "d32ca0e03d09475f8dbc068ea94b115299b9d87004343565e34cf0b07c052906"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/meta/fb303.git", branch: "main"

  bottle do
    manifest_sha256 "0572e4d6aa88ceb015e16a3f1503c9204953a813a5736bd4890e4c4aca6af095"
    sha256 cellar: :any, arm64_golden_gate: "6d4aadcf80652b5c590fb81e41197dc4ddf304b10a23fab476fc5b905b4896ce"
    sha256 cellar: :any, arm64_tahoe:       "aabba0bc11ef063c66be606106258205913dbdb3de2ddbb770e28d4f529b5090"
    sha256 cellar: :any, arm64_sequoia:     "04980b65c76c73ab6d0c89831d6624307723a7b6ea24045a8cfa9107682cfa88"
    sha256 cellar: :any, arm64_linux:       "cf131f5502d28ecfdef1a758ecefdcf7d364c28357a15ccdd6ce5c897897c22b"
    sha256 cellar: :any, x86_64_linux:      "2d43b40d2897aaad44dd7622b24a349abfb63cc954a3879a75571b8f33c0c890"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "fizz" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"

  deny_network_access!

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

      list(APPEND CMAKE_MODULE_PATH "#{formula_opt_libexec("fizz")}/cmake")
      list(APPEND CMAKE_MODULE_PATH "#{formula_opt_libexec("fbthrift")}/cmake")
      find_package(FBThrift CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)
      find_package(fb303 CONFIG REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test fb303::fb303_thrift_cpp)
    CMAKE

    ENV.delete "CPATH" if OS.mac?
    folly = Formula["folly"]
    if Tab.for_formula(folly).built_as_bottle
      ENV.remove_from_cflags "-march=native"
      ENV.append_to_cflags "-march=#{Hardware.oldest_cpu}" if Hardware::CPU.intel?
    end

    ENV.append_path "CMAKE_PREFIX_PATH", folly.dep("openssl").opt_prefix

    args = OS.mac? ? [] : ["-DCMAKE_BUILD_RPATH=#{lib};#{HOMEBREW_PREFIX}/lib"]
    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", "."
    assert_equal "BaseService", shell_output("./test").strip
  end
end
