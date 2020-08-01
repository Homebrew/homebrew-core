class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmt.dev/"
  url "https://github.com/fmtlib/fmt/archive/7.0.2.tar.gz"
  sha256 "7697e022f9cdc4f90b5e0a409643faa2cde0a6312f85e575c8388a1913374de5"
  license "MIT"

  bottle do
    cellar :any
    sha256 "36231fdda36c76540d1414dafc7a92803e0290cb19762eae3a72ee330c418079" => :catalina
    sha256 "a84572c5a180b9a507485ca959de9bffde03a3540ac71b291dbc6b52fe43120f" => :mojave
    sha256 "ca4ea44c89bb1ad7e69929414cf052d97e1238cb64d5dcc9dc11173ff9c3aa7b" => :high_sierra
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
