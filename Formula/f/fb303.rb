class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2023.09.04.00.tar.gz"
  sha256 "d6b28ca940962783e11000815fcc257d61f56db40e95efaa0d69ffa5fe358ce2"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "399b834f8bd45a9072a6b55e0e5b3decdb57bae5b63baa2669c00c310a80f7b3"
    sha256 cellar: :any,                 arm64_monterey: "d063f1602946a0dee57a795a795b0267bd6391093900d07844eececad584c6aa"
    sha256 cellar: :any,                 arm64_big_sur:  "818880ac806054f01a8d01484f23ae0db234118ff67fa490f3167b9893da98ce"
    sha256 cellar: :any,                 ventura:        "92a4139b80434558281242109509b25803cc4309f5a8f157cef066bd73c12b9f"
    sha256 cellar: :any,                 monterey:       "60e8940e65043d23dceec389cecb23ab0232da87e0d424867055bfce8fc2be11"
    sha256 cellar: :any,                 big_sur:        "bb2530fa5f0d5f405dbc24de8c30c87bdd34532a394ae07d47c48879af1725e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05879512b8f8dc22e1c99183292a84177d9ce4eb110a64cb9e95a00af4953217"
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
