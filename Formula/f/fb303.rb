class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2024.10.14.00.tar.gz"
  sha256 "fea915e78d7607fa38beb6ff7ad2fab8b634edf0cb58bffb260170a31e28ce7e"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "88b6ee041e3346eecdd9589a37cd78df9f77d1fcf11042f4e7b09dee5e812bdb"
    sha256 cellar: :any,                 arm64_sonoma:  "aff974fc9307a6a40e9a608f971ea01165011176f15b97d3ca4f4fd601741930"
    sha256 cellar: :any,                 arm64_ventura: "aa6537ad02b9bc144acf74b873dd5e16ebe891f87e885c7aa3e42243bcbdecc4"
    sha256 cellar: :any,                 sonoma:        "cb803b6bcb3ff2850a9b1d1911613f0f8b1d803a5cc067259f32fe676187d804"
    sha256 cellar: :any,                 ventura:       "1fb7d43d2ef7dc46188a3baa24284d235f0a2ea88d46e415eaea508dd0123a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42da91b9247e6939e8526710548193f9314c09b1a4ed8c416ef4fb17e634fe2d"
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
                    "-ldl"
    assert_equal "BaseService", shell_output("./test").strip
  end
end
