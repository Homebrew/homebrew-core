class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.10.5.tar.gz"
  sha256 "c8590568996cea918d7cf7ec6845d954b9b95ab2c4980b365f582a665dea08d8"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfef5a915c30a90886b9ad075ed61c8c84654c5f04011363d7ad72663877c529"
    sha256 cellar: :any,                 arm64_ventura:  "08e9fc350ee4025479697f3f147277ff44c5383c1417df9e4119f5ed2993ef4f"
    sha256 cellar: :any,                 arm64_monterey: "7e81fa0e233c1ca7436de8a2986546855da6e82644b251236dd08a706eaf3a44"
    sha256 cellar: :any,                 sonoma:         "32cb1fbdbd64c5e9594b8ace3cb7919f20a0474dfd9e83bcf67f52eed7e43fec"
    sha256 cellar: :any,                 ventura:        "b646edcb9ee136607aaf911521a28aa4916b0b9eb8e5ea8f3bc2faa655c64406"
    sha256 cellar: :any,                 monterey:       "99b0acc646c669aceb3d53729da033a3ab4263e69d65e267e778a825e5f8600d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5238ed4fc1a27b5b501e68ba01255e01fadd98398e67c709ee0c72e58c144aa"
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
    args << "-I#{Formula["curl"].opt_include}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
