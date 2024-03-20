class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "a6618d2a4f8463e5358d7fc12961f66fed8ac9de1187a932e54d95919fc5b601"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9bfb0079b86d44a9da1a58de02163f3f04b3bc5923e5cc8338b5366d4bff6403"
    sha256 cellar: :any,                 arm64_ventura:  "3af0b4684ff95e42511cd243326aafa4eccf4f20c0f2f4e4c6d75e6ea101b75c"
    sha256 cellar: :any,                 arm64_monterey: "95e157aeb4281ac373821bb19dcb888f8197d3255b4d496a8892560c8d2cffb7"
    sha256 cellar: :any,                 sonoma:         "e446a6d26db1cde05f12d1e014f9f1c9fd72bd4055f3d7c1cd7ae642cf63003b"
    sha256 cellar: :any,                 ventura:        "d070fe1bdf4300e1cf1fed1e322cf3f42f29d32bd426ba9fc5121d451fadb840"
    sha256 cellar: :any,                 monterey:       "baf7cfd735ffac4961a39a0ad95560686be317024dd00c6dbd0280a3d9a60231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b7c5eed331fb3423e3bec9583caa1d32fa226a43c16f465b1aabc749751d1c"
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
