class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "0c3fa54a3ebf36dda0ed3e7cd5451c964afbb15102bdbcba08aafb359a290121"
  license "BSD-2-Clause"
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "36af0dc46c37f63d7b95d5fbbfd6faedb587b0f66994022486b6216cc1b4a620"
    sha256 cellar: :any,                 arm64_sonoma:   "badcf6bec2378a87e78207e2b378d525a75ce0fc3511e47c7dc10fc8e5ed5fbb"
    sha256 cellar: :any,                 arm64_ventura:  "6b959115733d494a5a6cb3256853e368313eda71d1df964ae2b67496e092f55d"
    sha256 cellar: :any,                 arm64_monterey: "c2514a95c8f9e08c8c9792ecbc78397fd1c8e52069cf16fdaf87d9cc1cfc8de5"
    sha256 cellar: :any,                 arm64_big_sur:  "36f09677be96fe1f60945c6d16c0bbe48b51d898443420f6360d07c478c1127c"
    sha256 cellar: :any,                 sonoma:         "ce0a3ba8a87a944fc5d1ab48efc3fd69db79d10c8d5224231e690b6de23f788b"
    sha256 cellar: :any,                 ventura:        "f1312db2dadecaabd79c4539f9d19dfbbcff6320ac1e3f019dc2696938eebcfb"
    sha256 cellar: :any,                 monterey:       "091cad450a37fbe0b51d83a0302260eca95f872d6d272811df0b82319f37d822"
    sha256 cellar: :any,                 big_sur:        "646599aca3fac21f7e0d0f9f3c02d28dae9f03bae2130d3866e7953125ee9779"
    sha256 cellar: :any,                 catalina:       "dce05e4517b703b8d41d7477fb64585b20d26cdf83e1bc1e591555e2246f6826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a22a520b128642ade29eded38b0c9e33c20ddbdcc6055f8522409a48b416df04"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if OS.linux?

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_OPENMP=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <muParser.h>

      double MySqr(double a_fVal) {
        return a_fVal*a_fVal;
      }

      int main() {
        using namespace mu;

        try {
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
        } catch (Parser::exception_type &e) {
          std::cout << e.GetMsg() << std::endl;
        }

        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lmuparser"
    system "./test"
  end
end
