class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      :tag      => "1.4.0",
      :revision => "3f76ef3fd6acecc7142cd181c8bd8ce1acb8cd14"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    cellar :any
    sha256 "31b3d6d47fe56afa134d75e06acb914f0943610a41720d754d10d6b19904316c" => :catalina
    sha256 "c0988aa83530bf48778bbf28595044c25282b10db1bdde7f73a84f994cdf0ca1" => :mojave
    sha256 "f72e1991559282e2f45ef3e92efe99aa7d864a5501085b0a127da50620760f6f" => :high_sierra
  end

  depends_on "cmake" => :build

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
