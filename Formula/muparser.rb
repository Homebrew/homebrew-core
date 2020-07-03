class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://beltoforion.de/en/muparser/"
  url "https://github.com/beltoforion/muparser/archive/v2.3.2.tar.gz"
  sha256 "b35fc84e3667d432e3414c8667d5764dfa450ed24a99eeef7ee3f6647d44f301"
  revision 1
  head "https://github.com/beltoforion/muparser.git"

  bottle do
    cellar :any
    sha256 "20da2f5a649d58f95eedc5a7aed844a818993efcf2fa9d54d46b2dc8e3822c12" => :catalina
    sha256 "a6f9fa4ce3f683cc0799887200f1e38db042541a6efe45eaf991ba8b38d8b90e" => :mojave
    sha256 "bdbf31b17693b892f6be038d84e0b06707d517562d9eac62158612162555aa4e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"

  fails_with :clang # no OpenMP support

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lmuparser",
           testpath/"test.cpp", "-o", testpath/"test"
    system "./test"
  end
end
