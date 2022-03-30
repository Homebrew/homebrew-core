class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.8.1.tar.gz"
  sha256 "9155ec36fcafe8cf8d61c98cde8dc6bd27c146740002069bf990855eecb2b95f"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "762abcd0fb7e48407e592ba6a9c0ed8c4e249ca69de5a5aa1dae72c7da403b21"
    sha256 cellar: :any,                 arm64_big_sur:  "0b45cfe51cde43bc34d3fc717c89b3a75cfe48d7d414cd53471c434835129f83"
    sha256 cellar: :any,                 monterey:       "c8e0f954e5c6e1a35c36cddda36c39d3641558d3fa97d7a96a6c0fc4d6cba01c"
    sha256 cellar: :any,                 big_sur:        "d1d3dd4fa29989de103e8a47c643081843ea9dbb83855ea6530f0a6d290c16d7"
    sha256 cellar: :any,                 catalina:       "57a942ca83e169a8b07af37258b574c06ffd10faddc46daa1da7312d32219cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e334f8513f9cc5b862d4486c3ee2a818d41433376137d4c5258316c800a33938"
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
