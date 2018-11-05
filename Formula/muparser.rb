class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "http://beltoforion.de/article.php?a=muparser"
  url "https://github.com/beltoforion/muparser/archive/v2.2.6.1.tar.gz"
  sha256 "d2562853d972b6ddb07af47ce8a1cdeeb8bb3fa9e8da308746de391db67897b3"
  head "https://github.com/beltoforion/muparser.git"

  bottle do
    cellar :any
    sha256 "30327cb512c873508e0a0db8b8b6af8e09eecd126f00462e2c8456cf54ad41f2" => :mojave
    sha256 "5996f6d2fab05dbf570cf2622f09bfa89998d923944d840c0e81c79ca69358a6" => :high_sierra
    sha256 "0e0432cc0a03c7657cae3873ac44a61583cc171218e78691c0b4d89105be4524" => :sierra
    sha256 "126f7a337787b326f4727d12bbd4e9758609a41127e4145fecc69db131be4e80" => :el_capitan
    sha256 "43a9e242f7abf60709e4b8fe8d629ddeb88d693af400d0e1aa894267b9d5b646" => :yosemite
    sha256 "e6945023b6e8e758c0fd3ec69d66119a60b3179881b4dedd18bdfbddeb75eb53" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
