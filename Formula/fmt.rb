class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/5.2.1.tar.gz"
  sha256 "3c812a18e9f72a88631ab4732a97ce9ef5bcbefb3235e9fd465f059ba204359b"

  bottle do
    cellar :any_skip_relocation
    sha256 "da972155cdc9897f1204e4edc01f8e5ff1bb8377398c0e141766a7fb4ecb8cb1" => :mojave
    sha256 "a07e95135a5f30a82ed33acbec754a098d8bb067af92fac76e5284e655c5165d" => :high_sierra
    sha256 "ac28bddecfb892da9bfee11f325d2250781f42149a06764211aa688e4dbf2273" => :sierra
    sha256 "c7fdc37809065820b45e4404c172d5f795b32bc2b20b00b3c1b7031b00aefae9" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
