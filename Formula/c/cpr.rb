class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.14.1.tar.gz"
  sha256 "213ccc7c98683d2ca6304d9760005effa12ec51d664bababf114566cb2b1e23c"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f6fedaaf9ada689d14bc1854d24ea140cb9c42bc4920bac7b7ab476705f621c"
    sha256 cellar: :any,                 arm64_sequoia: "48d1fd8759a8834695b3faca744b46c9da6977b2b2c5fc912d261a78a483e348"
    sha256 cellar: :any,                 arm64_sonoma:  "518ed4d3f72ee56e3c078e6d9233726c00248c26aad77c223ecbe21243ceaa12"
    sha256 cellar: :any,                 sonoma:        "cab1af9d093f2029d4b1fc0af5d6c15184734d3290b31f99ee61254742cacea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "516258c353c3a7524c61b540b98e9ad31863c3145cd212aeac87a6ea168bcdc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71bc13d254bcfe7b03a844b9d49a70b92806ce146d98a0e78bd41accf89debbc"
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
