class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.13.0.tar.gz"
  sha256 "c55d805300c224f099cad74ad9c68799f23d005d09ba2df76ead975a3e50e09d"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30d36b034765bd5897024fe87ab08313712f96a3ee614adeb7808658c019cb82"
    sha256 cellar: :any,                 arm64_sequoia: "a0d977e6bf0d2a2e35c506c31f8cbfa90387fe0765e946ac30d410ae366476c2"
    sha256 cellar: :any,                 arm64_sonoma:  "d2fc529fbe5e39b2060cf13886d149c88ae29bc98b706350e00473a58de4423e"
    sha256 cellar: :any,                 sonoma:        "0fd70be274ed66c4114b8eede879846420608e08b05b1662a9bad597190ada1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81474a9d4caa550e2217a5746bcf48e3fbc15dd9700147701a87a1eb6bd82f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27722b9d1d98990fef20dc2063493b42f67d6aca2e265b8c67dbd82f157067c8"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@3"
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
    args << "-I#{Formula["curl"].opt_include}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
