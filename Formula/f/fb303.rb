class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.12.16.00.tar.gz"
  sha256 "03a9e03a32c326de6fe77bddd0228017302fe5980842418c752a920d17d89c36"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab7fa461822d474d9f0d6c2b74f66c947755d49be5f94b51271ab0cf79c315e7"
    sha256 cellar: :any,                 arm64_sonoma:  "961478be2f4e9c8685fec0ba28b99e2fa59fc95fe1193ff83732a41d16f60fac"
    sha256 cellar: :any,                 arm64_ventura: "4b5f17bc8f33fa2e1140b2c87acea01853d035c2e051b3d1395c649463cd4abc"
    sha256 cellar: :any,                 sonoma:        "fa3c8654097ed4b5d96f415ecf8075ad7c249d87fb4f9995f8c6ceb94df50cfa"
    sha256 cellar: :any,                 ventura:       "665a72ace1f64a1c8d946ffef58ce3c62b43bc81dd45d544724e7d503f6f52fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4d3d13bb568b771c1bf903f451cea8abdf4e676efa36c7f1d4905124beaa56a"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXTENSIONS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "fb303/thrift/gen-cpp2/BaseService.h"
      #include <iostream>
      int main() {
        auto service = facebook::fb303::cpp2::BaseServiceSvIf();
        std::cout << service.getGeneratedName() << std::endl;
        return 0;
      }
    CPP

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
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
