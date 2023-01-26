class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.10.0.tar.gz"
  sha256 "d669c028bd63a1c8827c32b348ecc85e46747bb33be3b00ce59b77717b91aee8"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "daf5f4894c2478834e450baac837154179fc88a2ec3d7d06ddf6c3be24ad4ffc"
    sha256 cellar: :any,                 arm64_monterey: "2d53f0135afc4e4b3767a5a3293d7cf467830d7c0a634d663f4bfd353054991e"
    sha256 cellar: :any,                 arm64_big_sur:  "95ec7967fa535c4b6d80ebb3f5112f91b74432a372b4ee15b88fae50b5f9c3c4"
    sha256 cellar: :any,                 ventura:        "7fb242be16db5b1d40f897c9ae3c9c3707c4bae8550af47f27177106aff45eb8"
    sha256 cellar: :any,                 monterey:       "36a7fe15e003dd3bf20d1f8e3dbb8101ca4db8d52864b701ca5f4e956086d67b"
    sha256 cellar: :any,                 big_sur:        "8f04311199164cf7afb2d552b177fe0f61c0bae1f226161fb4bca5492e3dc3da"
    sha256 cellar: :any,                 catalina:       "58275768c618ee0fb50833391bcc6ffe4ed380eba1cb86ffdf65f2d935b3b140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeb29af6745f6c1503aae57ae9bf2e73615beae9e66626eb633501331dc3f8b8"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

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
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}",
                    "-lcpr", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
