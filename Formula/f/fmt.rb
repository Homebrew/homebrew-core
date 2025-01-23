class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/releases/download/11.1.2/fmt-11.1.2.zip"
  sha256 "ef54df1d4ba28519e31bf179f6a4fb5851d684c328ca051ce5da1b52bf8b1641"
  license "MIT"
  head "https://github.com/fmtlib/fmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34b5e506a3a4b204fc5b7bfeed88a68c21636a03fb9fe18f335bee6530fd6ba3"
    sha256 cellar: :any,                 arm64_sonoma:  "1046ef8370d738db0b1b31844068e04f6ba2e37f8f2971fd66317db20683a08a"
    sha256 cellar: :any,                 arm64_ventura: "c937ca512d3659428d16171b116a93b77356958b67963ca2444c1d932f35095d"
    sha256 cellar: :any,                 sonoma:        "7c665fc73469d4322a4f2739b84ca45feba1eb46adeca2ad507b772358ef8a41"
    sha256 cellar: :any,                 ventura:       "9155a09ab31fb52c3b4c963c6177ed1f6035896e8d584cb873a9f463fcb21e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8be2c52165bba3b7bde1e1c0fa2ccfbad1f76299434da9e29f8857d9e00ee55"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
