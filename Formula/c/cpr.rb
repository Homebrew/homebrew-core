class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.11.1.tar.gz"
  sha256 "e84b8ef348f41072609f53aab05bdaab24bf5916c62d99651dfbeaf282a8e0a2"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5761b811cb868c87f715f4126c99beeae1d08574718a1863ab9db461ed6c24fd"
    sha256 cellar: :any,                 arm64_sonoma:  "eb169169df651fb87ca6f4fcd8c31dc195375c1b60e108208d5d816c3d406f0d"
    sha256 cellar: :any,                 arm64_ventura: "118ce16912d68e08066bcb3e5310c19d44f592dfd0a3d5762d93e4f8ccd060dc"
    sha256 cellar: :any,                 sonoma:        "5fe94c2c18cdc160c2a884cb07398cf8839e8c9645301fda881d817e48cc1213"
    sha256 cellar: :any,                 ventura:       "941cca13b62d8d0124bfe6d718d304b3f0a79505c8161c60b5e7af22bc7fb4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a37cca4bacbd1624f234b5e3696b30b278b3f7553437047d8b9c36324a209ae"
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
