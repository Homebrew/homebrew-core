class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.15.1.tar.gz"
  sha256 "c2fc62a030c4ca5d7c3517e8068531297f938bf4ab52bf951d4fc9bbc9222716"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "696661a3d885fef73825a5507ba4ef0a435cab6647d65e45e50bce93d95f0912"
    sha256 cellar: :any, arm64_tahoe:       "1766c94e773c3771b321ba834e1acde1517383d8bb818d28f36cf13291850897"
    sha256 cellar: :any, arm64_sequoia:     "478826621f526abce3e20d3ef5870ec5cdfa7dbac6ca32b8ef26510e8364f881"
    sha256 cellar: :any, arm64_linux:       "0fd21a16e95efebd01f1ee9a54e3a408c9446fa9dcb3439d8998c615820073f7"
    sha256 cellar: :any, x86_64_linux:      "40be696eab85b3058cb938d2c125c234f1ef778c908ac5e0f0be16f6bbc096b2"
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
