class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.05.22.00.tar.gz"
  sha256 "6d4f4ae4534c2a15c05410d4925e764db9c3321fed39abc78b6a728a6c1a9aca"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e925ca22ab0859e79e6b21a07f04f672638d351715abebf5373095611341c95d"
    sha256 cellar: :any,                 arm64_monterey: "6b4e532a8d4be0647ebe3352044fea832a6f13d27c09eec2249d7b8b06863d23"
    sha256 cellar: :any,                 arm64_big_sur:  "9305cf5f0a0fed2b49bcc1f112f7227ecc31932518cfa393592eec0295047f23"
    sha256 cellar: :any,                 ventura:        "1e0526947ad3433ae724a88412c0c314dade6fdcc7ff09b226b033526fbdf4db"
    sha256 cellar: :any,                 monterey:       "77298b76e1ddb34d8a1a7fe4467710e038ad417f36ebb64e335295dd7ccfd9ac"
    sha256 cellar: :any,                 big_sur:        "36196a6ed6efe91a971fe11604510cd69b8fe0cce322d8169e9dda72c42d28b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c638ff56d0278dcbfa1e6c8b92e21513054848d1e06ea1dc65172c6ea7bde47b"
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
