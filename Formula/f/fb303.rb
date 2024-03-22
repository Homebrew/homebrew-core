class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "a6618d2a4f8463e5358d7fc12961f66fed8ac9de1187a932e54d95919fc5b601"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de345922f065a62572db66cfdcec09291db3e1642130ae4f2adbb552489598d0"
    sha256 cellar: :any,                 arm64_ventura:  "0b8f93e68226c204d50251bbfbc0258f2717fa34379cc03f0e62547f03b6fb0c"
    sha256 cellar: :any,                 arm64_monterey: "559e616e15f07081e091809d23d451207b109de8e6f491190a29d5f003569430"
    sha256 cellar: :any,                 sonoma:         "ac99830829800334825af18ab7f14eb52b7b3b16eec51933b9c617f03e8d2f07"
    sha256 cellar: :any,                 ventura:        "421d9a00f5d47bff31f810844adae6e9aaeec7ac44c19a486c6e75afaf6d5e0f"
    sha256 cellar: :any,                 monterey:       "cf00b193b0d583b5e7e4dcd2ee8061fd95a925283b945a3d2ec17c18da0ce42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41ff87713a0898af3f8181eccb09271f085e61e63580379febf6dd1f0c837467"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"
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
                    "-I#{include}", "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfb303_thrift_cpp",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["fbthrift"].opt_lib}", "-lthriftprotocol", "-lthriftcpp2",
                    "-L#{Formula["boost"].opt_lib}", "-lboost_context-mt",
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
