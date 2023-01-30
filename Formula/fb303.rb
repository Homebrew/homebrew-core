class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.01.30.00.tar.gz"
  sha256 "e11ec912767a5bcd76fce60860db7886ee2cd4dcb13df424e3618b3f80351fc1"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "330bccee1b226ad450f0c8419a69e23a4d970edc2e617c615936ac141634f81f"
    sha256 cellar: :any,                 arm64_monterey: "a25cbaeceea563af7b543fe7c5f390d71f0e4236a75000a48cbc75f5d4bd71c3"
    sha256 cellar: :any,                 arm64_big_sur:  "9689078bd0cf479c1f74bc5a6e09f16b8a0e83725d480259e9013d6e01fd2629"
    sha256 cellar: :any,                 ventura:        "0b8fb40423d06c8339da275542804c658455280b8f707726f7212802bd19835b"
    sha256 cellar: :any,                 monterey:       "c7269f82479c599f24a725cdeefbf9c886b0ed75eae75a4c6a8e5089f38bb463"
    sha256 cellar: :any,                 big_sur:        "de39e466b10127d159e9c3a2a4b74f7bc39cf13f68d4e38e93b247fd5882fbc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcf5b8d58f7f692bdea20a65a813333953486417634179747dcd92571f0b6f37"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@1.1"
  depends_on "wangle"

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXTENSIONS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
                    "-I#{include}", "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
