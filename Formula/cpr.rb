class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.10.2.tar.gz"
  sha256 "044e98079032f7abf69c4c82f90ee2b4e4a7d2f28245498a5201ad6e8d0b1d08"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5f1e95a19a2bca2ddb84d3b282d7ea0d510c7ac6921ab9e3e533d97ec06f559"
    sha256 cellar: :any,                 arm64_monterey: "3ce258dc17e1e9d865d1b0ac361140ce89bb2fe69f14add602dcf5ee230469ea"
    sha256 cellar: :any,                 arm64_big_sur:  "7514ae75cac424868e780bee6c7ea7fb7b1edb1635601dcc6ae908af81682499"
    sha256 cellar: :any,                 ventura:        "bec11a104839b5ad7e60ce5de3f919094ee5fb95013d818d20dd00ddac1b4c4c"
    sha256 cellar: :any,                 monterey:       "68bc31bb27bd4bcd5b0c0914326cd560adca28c2a0e0753feb45cbe43deaad40"
    sha256 cellar: :any,                 big_sur:        "c98eba2cbaf7fcee1a438b328425da26d9cff676f3dcee874a9cc9afb22f226f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec538aaf383b6e8c7130f6fd6fdbd31c8d6dac5e45bee5653f7aae378ed104d8"
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
