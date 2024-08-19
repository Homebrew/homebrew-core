class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.08.12.00.tar.gz"
  sha256 "c741c098f4f7c3e14a9803a1a59adaf1f65e68449973d3603f409704491cb3ba"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "828a0686f087dc8b7c864c0a51e920bab8401ba6ad3b55ad92b2c8d3aa55a67e"
    sha256 cellar: :any,                 arm64_ventura:  "10a3e666176e103d82c689709153854627933c6f033f03c82a4ea585bed8b894"
    sha256 cellar: :any,                 arm64_monterey: "158851903561bba328f08ef79a62106782be64ee2fe7b000b78bfd33ab629299"
    sha256 cellar: :any,                 sonoma:         "07112f2d64a53bc3d2b507423f4261f3582171875a895256b3ae0bbc21b1575e"
    sha256 cellar: :any,                 ventura:        "fac8098304363bebdd9bc69ecb4152390a25c06975dcd56ed331c2086b20bc64"
    sha256 cellar: :any,                 monterey:       "cb20e7e16441d6e211afd79aee0fa19b239ce88ec062ae6e50ecef5bde05d5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef70dc34da50e53263bde1675198987d780e8cc0fe9541c90945366888cbc1c"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  fails_with gcc: "5" # C++17

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
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
