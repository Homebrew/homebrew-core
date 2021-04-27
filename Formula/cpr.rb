class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://whoshuu.github.io/cpr/"
  url "https://github.com/whoshuu/cpr.git",
      tag:      "1.6.2",
      revision: "f4622efcb59d84071ae11404ae61bd821c1c344b"
  license "MIT"
  head "https://github.com/whoshuu/cpr.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "148fe92c19acedf327f3391d9d27cfdcbc9827402d7c19792711279fab011900"
    sha256 cellar: :any, big_sur:       "01d2a7feccbd41e4c1031f4949abdd32219ecd4c352ce7b422ff3a5b9a4acabb"
    sha256 cellar: :any, catalina:      "20cbfb4275787989ed99d346281a14b033703b53dcd1c81e3870d085e6a4002b"
    sha256 cellar: :any, mojave:        "d9125cf69063f36f241a66160bac0143c0602e66251326900b31053cfa2bae72"
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
