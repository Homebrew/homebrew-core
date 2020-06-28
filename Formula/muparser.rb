class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://beltoforion.de/en/muparser/"
  url "https://github.com/beltoforion/muparser/archive/v2.3.2.tar.gz"
  sha256 "b35fc84e3667d432e3414c8667d5764dfa450ed24a99eeef7ee3f6647d44f301"
  head "https://github.com/beltoforion/muparser.git"

  bottle do
    cellar :any
    sha256 "2a87b69702d3acb7f1e97cb090c891189465c8dc3692714361057dd8e586c4de" => :catalina
    sha256 "c0feb51e0b10602b323d46f49d898ebb4cb36e00dcee42963d61b6c7ca27c23a" => :mojave
    sha256 "611da2016012d77dbe1e5a9c85872cc8f8de23967b019ec039177b49fad2a0d1" => :high_sierra
    sha256 "d5d3fd87e54d300578836ed61e066ef08b665050d7986e46ed6995eeee819088" => :sierra
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
