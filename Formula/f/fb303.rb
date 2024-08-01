class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.07.15.00.tar.gz"
  sha256 "f914c6d4c14d95e333464eb1b21cbbf2045728db17d4628f0dfaf1a82643afe0"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "59dcfb41a8a8f7502dcc980db12ffbbda311351bd47d4ba3e53a3e6c4b1c7b20"
    sha256 cellar: :any,                 arm64_ventura:  "5cd2b6fec2055062679a68233ea1be0dbbbd8ed9b72b87923adeee19a0b8f148"
    sha256 cellar: :any,                 arm64_monterey: "819fcdbe7a3db8ff25db3dc8891de2e31ccf3f3e715fc0a689f307ae23848086"
    sha256 cellar: :any,                 sonoma:         "94d1955070d0e3425b35b75035b4f9dd9bd36c1cfc958898965408acc876e5e9"
    sha256 cellar: :any,                 ventura:        "7f0c2e6d6ce58cef7fd732e10edc0078b8f7e60d6bca1e35b1bc9c82d6f2d314"
    sha256 cellar: :any,                 monterey:       "0727c09ca5ceed92fedd232f05d8ec787971192ca7a62edeee173f09d04028d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2d711e11ffc05f20c0cbebf913824a84d62a689d3824e1a45635bc6484e9a15"
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
