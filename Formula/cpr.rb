class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      tag:      "v1.5.1",
      revision: "5e87cb5f45ac99858f0286dc1c35a6cd27c3bcb9"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    cellar :any
    sha256 "3de3156e76c50a9c0177f2f6b7856f83d36a7687d070c467acc9424a986a43b1" => :catalina
    sha256 "477db140c07296b4fb3969b26d136afd1b7106625082cb57dfd8c274dd53da23" => :mojave
    sha256 "b0c9560ba7c1fe39dfdb316541526494ea685f7c34944882ed7823f769e1cda9" => :high_sierra
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

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lcpr",
                    "test.cpp", "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
