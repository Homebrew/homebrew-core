class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/v2022.08.29.00.tar.gz"
  sha256 "7771f0b81a991748a46a3d9fc52df5ecbc19af01b05c327d52bacf804eef0edd"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f74c58ad3d2dbc1c6814d36a2fc50eca03725f32b8e9f80ae3ac5fa56d2fce11"
    sha256 cellar: :any,                 arm64_big_sur:  "3a52a5504a179c2acc3f2c8a5c868e7d8dd276615934b0d11780e28b828689df"
    sha256 cellar: :any,                 monterey:       "ae5e56334ba99715dec28d71e7127ee48cba476b98179cfb2f7c8e2123510d2e"
    sha256 cellar: :any,                 big_sur:        "22b209e5b22e5d9b90318a4fd060d48da581a4aab7755e2fc668d3b9de5eab05"
    sha256 cellar: :any,                 catalina:       "d1220013cc488c7a99084baca1cce4771704a9699ae444bd624b9aed97a1a2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2219567cf210891f53e6b4b6830f426f0b6e266a574ea9161f324fc563fc6b5d"
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
