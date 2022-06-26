class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/1.8.3.tar.gz"
  sha256 "0784d4c2dbb93a0d3009820b7858976424c56578ce23dcd89d06a1d0bf5fd8e2"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "610f141ca99ea251e5326cb26685fc509d750ab46157823ec683b01f919366f4"
    sha256 cellar: :any,                 arm64_big_sur:  "c2dba3a539bb400f185806a36209da06f18dff628059a2853d3374fdbd138ca7"
    sha256 cellar: :any,                 monterey:       "8fa911c8d3a1914c774f899a5746770070baf1cd72c2bea6f76e547486d1f96e"
    sha256 cellar: :any,                 big_sur:        "09c5d92ac8e2e19c581765df2a7a7430fb9af9146c809b046252082ac954cbec"
    sha256 cellar: :any,                 catalina:       "9a43c51be89eeab77ecbca2b575016b124099aadcbf1a13d356a750f382a0d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba40b91ac436b5a0e9faf82c6358eeacd37b72f7147ca90ed587ce2a53f8b1f6"
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
