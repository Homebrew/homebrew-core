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
    sha256 "c99b69d002f22fa51ca8b53f2add5a094effc2e81dcbda20cfdf483be5f96619" => :catalina
    sha256 "6b1ccfe8b7d30fff5de4eee181e878e285131365e8893bbb95d1838d255b808b" => :mojave
    sha256 "b1e0e3e51369d70e3c69045e07977b14e2c06ad6f48cd31a9621204be99a64b7" => :high_sierra
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
