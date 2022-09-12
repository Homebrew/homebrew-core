class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.09.12.00.tar.gz"
  sha256 "f10ea55b465c63a657d12c3489aec12600b26b67f8c8d702d92b50a14641687c"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "53a18cadd15ac6b68159d64e8652f2b8785b8dd9836247cd1c0778fcc356962a"
    sha256 cellar: :any,                 arm64_big_sur:  "b4084df59b4689146f1a64381bfd9018540cb43e0d97493d062fa6ea4b2f5169"
    sha256 cellar: :any,                 monterey:       "110dca2931763acc182d68666ab66b25ea51be09c1225f1bc20ab902a291a8c2"
    sha256 cellar: :any,                 big_sur:        "b679319ae9fd07013f97d99d12100fb3ce2800561faddd29fe28382c07b28aa2"
    sha256 cellar: :any,                 catalina:       "ee7d8a4b531996a96902de4c429e8a90a1dbddee589718c81e7f0a3b83487933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a31b400fa1fc7230d5049a53c0df1e383b93e24d71e3662a37e5ed3f4123eb2"
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

  on_linux do
    depends_on "gcc"
  end

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
