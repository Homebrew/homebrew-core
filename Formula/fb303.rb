class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.10.03.00.tar.gz"
  sha256 "480b36aa75d1de984f3ac5718d532c3004ab98a36f0e57e2e41254f0e332129f"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9857d7ed6b0ad79da42bf6c31c2f31ec3cf705423edfb279dc5c92a7cc25aec7"
    sha256 cellar: :any,                 arm64_big_sur:  "38ec8362601a1ef81d39af65664a07ac7d93aaf135f0eac7c84a19ac00f45936"
    sha256 cellar: :any,                 monterey:       "64224bacb7db7929554721315a6ea55920fde7b72de81f25b7d5da534f2921b1"
    sha256 cellar: :any,                 big_sur:        "194efc28eda4f1825012805d603a75cf55ba360222a0e482c6e49dd95282a686"
    sha256 cellar: :any,                 catalina:       "e92e8b0a9b980bfb9589aad25387e83c539f193ea3cb8b5920de36b268bf5d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ec6cdc2e244474e91972bbf5d216fd6f88e76fcc633b34db544e0d825d47fa4"
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
