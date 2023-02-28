class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  # TODO: Add back to `synced_versions_formulae.json` when upstream resolves:
  #   https://github.com/facebook/fb303/issues/34
  url "https://github.com/facebook/fb303/archive/v2023.02.20.00.tar.gz"
  sha256 "2e0c39a6fa1156cc8d2d79278a39e9150a7e76e045971c72086fc9c548e26c08"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "031a414f23c3e1f2392573730d7ea781eff54bd9c83e6370217dc21061bb10ac"
    sha256 cellar: :any,                 arm64_monterey: "47aaa3da374538031cf324a735d22715ab7c02b055800b984f231e4f732fc382"
    sha256 cellar: :any,                 arm64_big_sur:  "2281a40db9d47c3a4e85be982097a0a7c51172004ad831e19d3b61b29a1765aa"
    sha256 cellar: :any,                 ventura:        "378ad8bf15deea43626ed1a97dd0404a26a006d525c25d748d35f638cec94dfe"
    sha256 cellar: :any,                 monterey:       "f55c647972a94d90d0ed2c8e1019bbec71146ab92af9dca881ad9356acc02a37"
    sha256 cellar: :any,                 big_sur:        "f2c160078c850255b77d0a5a44bd1c59ae465da1dfdaca881d99c167e86ef8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191d184643000bca84d86d4a394f2fcff5aaa179a652b0aac8a6eaa0b2fe1f9c"
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
