class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/v2.3.3-1.tar.gz"
  sha256 "91d26d8274ae9cd9c776ee58250aeddc6b574f369eafd03b25045b858a2b8177"
  license "BSD-2-Clause"
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4dff9553e0c011b1ec56a9d32a3bd54ac58ff544a5b309b79eb2db9c7c0b260c"
    sha256 cellar: :any,                 arm64_big_sur:  "601cc1cb821fa272d4624708e6eb52d585389e6dcfbaa8eebaaa46faf090e7d4"
    sha256 cellar: :any,                 monterey:       "6d619d5abe92012c7141511fd84fe786dfca2e3af132a1a0dd8b5645561547da"
    sha256 cellar: :any,                 big_sur:        "72c1c442bc1eab9203074b8238a38b6a1f7fd7ced4ba76308c30af789db3867a"
    sha256 cellar: :any,                 catalina:       "344e11fdc3dcc9a64ca520dc707c9623ad0f20df2ea89d9596a2da953d868879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819cbd314313417a1057a6f71f6b603d7875d7a3f925914a88d51dd99a67ede3"
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
