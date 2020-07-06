class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      :tag      => "1.5.0",
      :revision => "c8d33915dbd88ad6c92b258869b03aba06587ff9"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    cellar :any
    sha256 "74202966e61defa4ad315d34ebc29d8faad8585f90207b4a881beaf7c65de069" => :catalina
    sha256 "3c77beee80978eb95c7f56e8ad524b164559f81ca0a3b632f2aee8f90b02925d" => :mojave
    sha256 "a34a587114287f9cc031b31dc268301334ee145d3acd7adad077194c00576751" => :high_sierra
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
