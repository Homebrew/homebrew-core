class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.06.16.00.tar.gz"
  sha256 "d2e23b45fa7cc2460733b934945276ecc57b6a2af35f01e8cdf2d78628401551"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "f64d38f09cb770a48a0d872f7fe2a260ddeddcd5ea448b883dbf937c5dc4b678"
    sha256                               arm64_sonoma:  "b683043963aa3bb973cea3dbe20493b239e142f0260fa1a66a5eb800bfd6a160"
    sha256                               arm64_ventura: "4f1bd4e77f675473e647ef71cbb21979c5e6e6689864505b66f6fea7ef5f5fb9"
    sha256 cellar: :any,                 sonoma:        "1e5e2eb99a504c5386348fd02699c155b036dcfe80c29569450251461d238ad0"
    sha256 cellar: :any,                 ventura:       "111f9773183cbb5aee96dc27b6588205baad5d488dc55a78189a69586234015c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6261f63dd72451185bb8893ec8a14102c94db61a1692b2f354476be90be22d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62bd28f7c0a5ea5c3fa8285b1b48bf534e9f61bc541f119b3957239c2362bc70"
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
