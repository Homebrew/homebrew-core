class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.04.28.00.tar.gz"
  sha256 "a79d60389c719af19db63d86512b9f6a9dd875369fb888d5a5a59a1d31e625a3"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "bd016acb53be1c8eb375b861631b584b4b675afe84fbb4f15d19e61c23836a88"
    sha256                               arm64_sonoma:  "809ca86fe95af700825f3b84bc88f0d224dc2137446e0bd3d39830b67021ef71"
    sha256                               arm64_ventura: "9bfd2aaf842f89ad8c39e277e8ab07aa31636396df5868fca8867bef36eb7da8"
    sha256 cellar: :any,                 sonoma:        "0131c46d5c27873b959c6dd37761e1de6fc7fcefb13738f288dbc0c0c5d17821"
    sha256 cellar: :any,                 ventura:       "67a198fdacce3afe9b7bc7ef4257b00f257465f36944834746450fc6a19a6dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f436442cac37620c970e910aabea9076924700b9764bf6f0f9aaae4df68106e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a6eb601d2116ee850ee41013f6945e2751f3bc70fa3767fb498593510ea6fa"
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
