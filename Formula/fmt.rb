class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/7.0.3.tar.gz"
  sha256 "b4b51bc16288e2281cddc59c28f0b4f84fed58d016fb038273a09f05f8473297"
  license "MIT"

  bottle do
    cellar :any
    sha256 "ecc628fabb67ff7f03a9fbe916ad629e30e6add398c84750c0af55ea5b261bd7" => :catalina
    sha256 "a037d74f6005e7df7b7f080b3a3f643c229e315dec0e948851f64cadaed4764d" => :mojave
    sha256 "6e5496f417d00981661d6d716125cde6b7e6502827735d3c0d726fc63407b283" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "make"
    lib.install "libfmt.a"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
