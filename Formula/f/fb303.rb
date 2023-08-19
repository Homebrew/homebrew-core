class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.08.14.00.tar.gz"
  sha256 "46b196c9f5e258123800c55af3692ff430eb345c4b51a7544a48d88627cbfac3"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8096987259d5ae860d6a9eb013646b182253639bdc4161ad756ad88ab8905491"
    sha256 cellar: :any,                 arm64_monterey: "bf04ca0b9a6f3b88b4b1b9b2326553605227dae98aaa8d844acefcc5f266444b"
    sha256 cellar: :any,                 arm64_big_sur:  "ddf0f1ca011357933ecfa91b0fa0803a65b3c436d739d06c398eb954558beb9c"
    sha256 cellar: :any,                 ventura:        "7269c397524bc0d5b596778ce8d2b7180ec5a12cddc90e665696900ea9d9f0d3"
    sha256 cellar: :any,                 monterey:       "5220b18adc0102ef9f68951f66a5f25381a70fa204636a4e9789b74cb41cbc66"
    sha256 cellar: :any,                 big_sur:        "9617ef15e0ac3ad0cd9d3fd8f21377d12723a58dbd4e66906f59edd59b6f2590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79065a2d7bed7133ab8c2fd6ffb90ddde9a36238bd6a8d8d1e4aa2246eff1f55"
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
