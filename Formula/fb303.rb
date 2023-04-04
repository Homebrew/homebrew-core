class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2023.04.03.00.tar.gz"
  sha256 "78eb4797c43566a49a34bc1719fa8f9982857bea0119d57a60690e68ce1c043e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "950dcfce4682f713b820172cca58eef444137ed740e524f81375a256531b41e3"
    sha256 cellar: :any,                 arm64_monterey: "0895d8c648ee0ef9fc2f35b1ba9ac9bacbdbb7a4d2ca4a4e565806b2f1ab94f6"
    sha256 cellar: :any,                 arm64_big_sur:  "9f3d98251092f36a3c7727cfa5e3acb003d01984d4a3a74d25c4e7cf1ddd2d6c"
    sha256 cellar: :any,                 ventura:        "df76d87771d94955d51258b460bebee174d0dd62c0d33a9741d0410f9ad97a92"
    sha256 cellar: :any,                 monterey:       "8cbeb237149bfd6d58a1e7570a4ee717e29e43954a94db2b437eee903cf1a6c9"
    sha256 cellar: :any,                 big_sur:        "76a7630d596db5c3505340e6dfb03bb549c4b126f1d8c9a348d55b28465b6ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7013a1767c630e26050362fd5bb82682ce78cffc253c6b84abd9c8c13bb7715b"
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
