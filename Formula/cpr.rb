class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.10.4.tar.gz"
  sha256 "88462d059cd3df22c4d39ae04483ed50dfd2c808b3effddb65ac3b9aa60b542d"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f52db0627a16d81f7a3c583403d8a483829380eb0fb43ba5aa02facd61197af9"
    sha256 cellar: :any,                 arm64_monterey: "dba0fa6a2756d6f72eabd0a6c94d14f531b44160968806ef63d594ad3b0f8b52"
    sha256 cellar: :any,                 arm64_big_sur:  "dbb3e0c82cb8e5c8b635281b4dd7ddc8ae43a05b9bfec945226c4e009940731a"
    sha256 cellar: :any,                 ventura:        "1a4c07b4ebfef58ca98089dda3a3859afe1ccdfaecde0a9a80b5094f7643cea6"
    sha256 cellar: :any,                 monterey:       "623ee04a2a672e1ff1cfd94ae1f5f791f3c790f6a322b05f363c0b3014b40d81"
    sha256 cellar: :any,                 big_sur:        "b42dd113f236f40bb4bb7dadb86ce35b1831cf288ac732122f20c16bf570cb5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a40a748f7a33446daa2c780f1e69286830d6f2f3d7e2e1bf647eb7f158525880"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@3"
  end

  fails_with gcc: "5" # C++17

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
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{Formula["curl"].opt_include}" if MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
