class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.04.29.00.tar.gz"
  sha256 "b2227ea547a280b3bfe859433bb52dd6fad1315a0fe48b6e6573e6eb8c96898e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bf48d2b13567958bc50cf8cd5dd189a40ef348de4a57dbe2ea067e8c56513a9"
    sha256 cellar: :any,                 arm64_ventura:  "500a6b4257ebb9addd2b41bc76018b116fc9a09fc3f5fa15f407b62931c7f620"
    sha256 cellar: :any,                 arm64_monterey: "77e88cf25ed5659cc17ee040d1ed1764e1757ff5c94d41714227c1408320e390"
    sha256 cellar: :any,                 sonoma:         "36b252e32b5ac0f957a70ca46d5a745d840a3a78d90ed1f59c89a03b54403ff2"
    sha256 cellar: :any,                 ventura:        "c5a6e5d728a7ee00ece144e5df67a5a0e5a1593f79234be223231ad3bb2ed67f"
    sha256 cellar: :any,                 monterey:       "c14b352e37d994a855dacbd135ce94d40e866a25dd98bbf780c37d8ce0e1d8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e153e2ccdea4035fd46f3441462f3504f589aaf2435ad1e4500db88d048b51f7"
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
