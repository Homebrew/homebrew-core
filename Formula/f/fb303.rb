class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2026.03.09.00.tar.gz"
  sha256 "181667e31f10171053da03ea568e40f5cf90582c153b29e6d7cda62d527a1624"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "0a808a63ee60b931f4828e10d41bea0179c9a0cd46100f527db74f4cd5aa853b"
    sha256                               arm64_sequoia: "d6b593c2bc4e3b5d397e9544dfaa48b44767d8b67538c99a0288d91998a8c046"
    sha256                               arm64_sonoma:  "0cb82ffd341653b7012e4dc2cb97b363fc6f8df315bd55bc550bd563a1e77f96"
    sha256 cellar: :any,                 sonoma:        "4f70f5d6b91a15945fbe168d3eabea982a1c219d8482595026602cb9a1a2fad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e341af852c1f86f706ba9f9c8184e42bbfe8c112f244ddfa724994c953eda76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b4fc0525c76bcdb701bb160313e59b16a9ab9605b502361e70274f2026b163"
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
