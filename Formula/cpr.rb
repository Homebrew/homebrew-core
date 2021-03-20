class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      tag:      "1.6.0",
      revision: "aac5058a15e9ad5ad393973dc6fe44d7614a7f55"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b93aecd08cd2c187694a572c2c9c8d4cdb0ed181b4387fd3e7a68f67a4847d6a"
    sha256 cellar: :any, big_sur:       "0f3457ec4a948fb235d26d9bfdd0c1b3f53297c0e7c505a1f34a3d853907ddc8"
    sha256 cellar: :any, catalina:      "51bbf276165a820d37e9d9dfc829e7dae6f100b57bbb4095283955924027a7e8"
    sha256 cellar: :any, mojave:        "66cfe69826f724c686417117ba2ef710e7765a35c39b648d6d239867f6c47473"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    args = std_cmake_args
    args << "-DUSE_SYSTEM_CURL=ON"
    args << "-DBUILD_CPR_TESTS=OFF"

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
