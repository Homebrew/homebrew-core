class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2026.01.12.00.tar.gz"
  sha256 "e455652551702d040b9ba7c9e3991f556c851fc513fd28b039a56127a1190dd5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "a2ca11b554ea9b7110a5a897a78efe7c908e816d7ac7055d683378629239a331"
    sha256                               arm64_sequoia: "af12a8e70f3c967fcf69ced337f68a5965f1aa22194f0af40e548d2db06a6ca1"
    sha256                               arm64_sonoma:  "0390e77b75ddbccf590874c04c36e434554aea4a6e7cfde26bf3feadb13e3ae4"
    sha256 cellar: :any,                 sonoma:        "5b266a720a5708b3676e4789ecc490ce3eea7b455a46fea786168325f67d3628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a48765f312636e7109a0d8db061767d0805a7ffbd112ec2dddf5e025d6807995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc0acecdb8da793d006c74a8b8202282beff9f5d85fb80e2974394350a5d764"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "mvfst" => [:build, :test]
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    # Workaround to build with glog >= 0.7 until fixed upstream
    inreplace "CMakeLists.txt", /^find_package\(Glog MODULE /, "# \\0"

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
