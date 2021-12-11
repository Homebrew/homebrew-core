class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.7.2.tar.gz"
  sha256 "aa38a414fe2ffc49af13a08b6ab34df825fdd2e7a1213d032d835a779e14176f"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b51e1d2ab572a44233af616e93514e967df97deaf9c177f8f07c70a6f4b1a284"
    sha256 cellar: :any,                 arm64_big_sur:  "f63146e59d861d2064ae93d4cab94b5038da79e5214fa6d444dd856acd58e784"
    sha256 cellar: :any,                 monterey:       "16af5fddcdf200cb552012c17bc51a7b440b87f3de31dffc66321bcad06487fc"
    sha256 cellar: :any,                 big_sur:        "f51fbaed9fa4d4160a3a9425bc3969c30c81f82ee7a19c2f2b549c6138cf1c38"
    sha256 cellar: :any,                 catalina:       "1c3cbde56f9cc5a1a30fc8b3bd7d3ce210ac51119238781ba2540d09264ea234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7347deadd9536ff04e39f6ccb648d5105c4da5fce79145e6d46f43785970f6f"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    args = std_cmake_args + %w[
      -DCPR_FORCE_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
    ]

    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=ON"
    system "make", "install"

    system "make", "clean"
    system "cmake", ".", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "make"
    lib.install "lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}",
                    "-lcpr", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
