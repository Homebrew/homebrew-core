class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.10.31.00.tar.gz"
  sha256 "ee41ea55ffc5a4b84f80d10a966c60e2c668b6e8c75a53a20610f9bd43f416f4"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f32b26e1636c10d3f9fac13b069582a3c0e203269a7dada0779bc1a572feda7"
    sha256 cellar: :any,                 arm64_monterey: "ebf633dca2ec26892a272329c02dfad1db4689f9020776e45b4e62343802bcbb"
    sha256 cellar: :any,                 arm64_big_sur:  "7454588a956ad9ca05f0ebeac5f8143f80a8cb49e58ac178540dfc3100fffadd"
    sha256 cellar: :any,                 monterey:       "5d25cdf162fcf5f727b509bfb6ea18e968d4a912b91f3a962f4e7a494e2f0af0"
    sha256 cellar: :any,                 big_sur:        "a8d4f1f38ae21e023722c6f0a0a167e6b49b2dfd24a63b7715ce58773c379b83"
    sha256 cellar: :any,                 catalina:       "2aaccfd9772fe297a845bc1ced5d106f5e474c349be13545ae2d55ec3bbf26d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938342d5a1e157d4506592d8f09b4f0749f173443c145e7c3cd6c838fc56763b"
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
