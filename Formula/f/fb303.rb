class Fb303 < Formula
  desc "Thrift functions for querying information from a service"
  homepage "https://github.com/facebook/fb303"
  url "https://github.com/facebook/fb303/archive/refs/tags/v2025.03.31.00.tar.gz"
  sha256 "cea41a67c2848a090dfec85c46fcef526685d57bc5f36d452eeaea199d2f6ac3"
  license "Apache-2.0"
  head "https://github.com/facebook/fb303.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "7531bfa125017c0bdacad831d395c9a450dfde965595d538b62022da9b5ab518"
    sha256                               arm64_sonoma:  "125a803ac423784ee02c3e304aa9ad93c3a90985741f2b2fb4d0b414e571cfe6"
    sha256                               arm64_ventura: "86a2220eeb203e6f5080ca8cac5c43b11bce910b300839049cdda2121a77ef03"
    sha256 cellar: :any,                 sonoma:        "e9f75b27de79efeba83424c6df976eb73351b762639f08b9f6fc011d076e7f3f"
    sha256 cellar: :any,                 ventura:       "fe03a862d0bd246f4b21feecb5a56459eacc19ca505e0d40bbe5df1f6fd750b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1cee0209afc10b8577ede2bc06c94613049ce2ce3a9a474f4098fa65c8f3a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ec078e445f16e5ec5ed2b2b66970a1c864ad9fb4758f9248202dd32b8dee98"
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
