class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc39c1ae9eafc52f447f685e3441fb31f980efd0fb0345c969871c9cc8d807f2"
    sha256 cellar: :any,                 arm64_sequoia: "11733a36d494bbd6ff343b30f8e0ed776660c41e5e1ea88ffedc9eedadca2ce7"
    sha256 cellar: :any,                 arm64_sonoma:  "b1b39c12aa16a0a6fd45b232594448b7c180a16f182246d9cf7e884a019be577"
    sha256 cellar: :any,                 arm64_ventura: "c8f1479dae9c99b52c1e0efa102eeb876c5e721741fd805963e4f1694eba772c"
    sha256 cellar: :any,                 sonoma:        "316542316198bbd354327695a2b3a1e8094e0f05b8f314c0cb3470e8d45c527e"
    sha256 cellar: :any,                 ventura:       "d6854bf7ee7a512856309611cbbe6ae0aa5da588c6a886c70499779f34397dc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba22f437decb80c8ed700338c1213c2a19e4e260122acfe1732f1ca54f836ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aff0ff2ecd2d9717123b66a7d8cb5ac087519a198085e14c22ce5ed682c2fe19"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
    conflicts_with "gromacs", because: "gromacs ships its own copy of muparser"
  end

  def install
    ENV.cxx11 if OS.linux?

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_OPENMP=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lmuparser"
    system "./test"
  end
end
