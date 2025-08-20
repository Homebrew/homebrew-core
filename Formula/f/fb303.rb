class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "69123178f5e00c0a507a82dc5cd33ff81300ee3a50d7951425d9f5931ee8fbbd"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "9513f307551a6a96beed42bf4cd4d979860001394ab68c51549bef8fd800be43"
    sha256                               arm64_sonoma:  "9ddb8af44d67dade791354839ae64517317ed79cdba52a6a983bb68fc36efc4e"
    sha256                               arm64_ventura: "53d53c2f04d73c0a7e1f1bb224d60f456bf3ac9776e8dfdb23fb647e9ebc7fac"
    sha256 cellar: :any,                 sonoma:        "1d7eae31ef548adce4dc101aa5ca5a7d5c9892e513d07f99a508314895ccbe29"
    sha256 cellar: :any,                 ventura:       "8c035aba9b22ce3171f167c8441a1ff3837a14fdb7980bf7f0d7979a0a10a384"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fecc9a5bad9c4e680c04e2de43bb570fddac1c8b966b4756ce2d2063e2a896a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a33186121f583cc8894377c6e2156c938703726a5bc99fb95ed193f9ec6452"
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

  # CMAKE_CXX_STANDARD to 20, should remove in next release
  patch do
    url "https://github.com/facebook/fb303/commit/ac1a8c3fb522f8a08d96ba831818912e18d565d9.patch?full_index=1"
    sha256 "f048ae3b053822114fd692967cf7b8e8f0b362711699e65007c406b31d67550f"
  end

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

    ENV.append "CXXFLAGS", "-std=c++20"
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
