class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://beltoforion.de/en/muparser/"
  url "https://github.com/beltoforion/muparser/archive/v2.3.2.tar.gz"
  sha256 "b35fc84e3667d432e3414c8667d5764dfa450ed24a99eeef7ee3f6647d44f301"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/beltoforion/muparser.git"

  bottle do
    cellar :any
    sha256 "0a1a8ee3560af0487a46b7c524cdf938b1d6e159e6c4d9689968225cd6311713" => :catalina
    sha256 "3094837032e20cbbd5e74531a20450af6986bfd5ac83ea4df4884a538a552c85" => :mojave
    sha256 "ca242a645a77e528c16cced97cf06bc796071c549a8d81f22bd4d9bd547828fb" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_OPENMP=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "muParser.h"

      double MySqr(double a_fVal)
      {
        return a_fVal*a_fVal;
      }

      int main(int argc, char* argv[])
      {
        using namespace mu;
        try
        {
          double fVal = 1;
          Parser p;
          p.DefineVar("a", &fVal);
          p.DefineFun("MySqr", MySqr);
          p.SetExpr("MySqr(a)*_pi+min(10,a)");

          for (std::size_t a=0; a<100; ++a)
          {
            fVal = a;  // Change value of variable a
            std::cout << p.Eval() << std::endl;
          }
        }
        catch (Parser::exception_type &e)
        {
          std::cout << e.GetMsg() << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lmuparser",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end
