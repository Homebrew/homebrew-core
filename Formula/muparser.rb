class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/v2.3.2.tar.gz"
  sha256 "b35fc84e3667d432e3414c8667d5764dfa450ed24a99eeef7ee3f6647d44f301"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/beltoforion/muparser.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "247811d2beb59f456963c712936a90cc3a9364cfea31ce4f66f23d6f45faded0"
    sha256 cellar: :any,                 arm64_big_sur:  "aaeffc1af6b24928270c796679326095b390f3d998f91962b58aa3f7b3581f87"
    sha256 cellar: :any,                 monterey:       "c309a018ca89e6650685397f9218d0871ee6adefc6a3a8efff94a455f855a02f"
    sha256 cellar: :any,                 big_sur:        "b7c21016c81037618b2e0148b52567c13f2d6f955d39913770e840a07dabecbd"
    sha256 cellar: :any,                 catalina:       "0a1a8ee3560af0487a46b7c524cdf938b1d6e159e6c4d9689968225cd6311713"
    sha256 cellar: :any,                 mojave:         "3094837032e20cbbd5e74531a20450af6986bfd5ac83ea4df4884a538a552c85"
    sha256 cellar: :any,                 high_sierra:    "ca242a645a77e528c16cced97cf06bc796071c549a8d81f22bd4d9bd547828fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d327476ca7ff9b992284dc6ce9d31ec387a8bc2f0c7ad14078393a1e463ae86"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if OS.linux?
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
    system ENV.cxx, "-std=c++11", "-I#{include}",
           testpath/"test.cpp", "-L#{lib}", "-lmuparser",
           "-o", testpath/"test"
    system "./test"
  end
end
