class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.14.2.tar.gz"
  sha256 "b9b529b47083bfe80bba855ca5308d12d767ae7c7b629aef5ef018c4343cf62b"
  license "MIT"
  revision 2
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "959ca8e8321668c7eda8055c08ed3b2be1f4760b8baebea7c3087e01be619b75"
    sha256 cellar: :any, arm64_tahoe:       "286d12eebbcb7434e491f80c562bb456413123638c1f177184de6c5f3a8e9ed3"
    sha256 cellar: :any, arm64_sequoia:     "b1322bf8804b511afe573984f68beb532209c938c69929381f71bbdf125ada2c"
    sha256 cellar: :any, arm64_linux:       "3dab5e5dd8d24d8eab0062c9bbe37fed1ff389922f9641cc4f9f9b884318b5f5"
    sha256 cellar: :any, x86_64_linux:      "55c0a5d660cdb67a5a637f5159cc9cc792bbdf6c2e256e6269a7d7bec3bb9ddc"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@4"
  end

  def install
    args = %W[
      -DCPR_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ] + std_cmake_args

    ENV.append_to_cflags "-Wno-error=deprecated-declarations"
    system "cmake", "-S", ".", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "build-static"
    lib.install "build-static/lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    CPP

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{formula_opt_include("curl")}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
