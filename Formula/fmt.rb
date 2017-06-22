class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/3.0.2.tar.gz"
  sha256 "fa4a062897b2f3712badfdb8583e6d938252e1156cb5705c3af87705dfef3957"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6a6247c6c8ad0a40df3173a3a28c3064f4741e9970ff63252251691b7a4146f" => :sierra
    sha256 "34ffe6f55356bbffd9ec0a976a107503a3d0070831ed8fb6d50023e3e99dd457" => :el_capitan
    sha256 "908d5d7a074af5e0809807b996d0fee7008b779103e2978aad7a17a81212404a" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
