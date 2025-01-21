class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4"
  license "BSD-2-Clause"
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1113ea6b1913855729476842599df799790e20a1932e14e6c4f824c8e7d10235"
    sha256 cellar: :any,                 arm64_sonoma:  "31cff23ae8fd7aa82a5a48747d305fe3d9d85c9c5e49d4f9b36bd749fad54e20"
    sha256 cellar: :any,                 arm64_ventura: "797c7bed4369fdc9336cb94511fa3d8247d050a2cfbe0cdd5570d9da5aefc236"
    sha256 cellar: :any,                 sonoma:        "96aa82b24e90335059f9a56126cacdd66da217e135d4abe03efc06348233ffa2"
    sha256 cellar: :any,                 ventura:       "45f32d38274e9b064eda6ea30418f5aea0a2a5c05ce914a40dde1025da321191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae8f1d67d9c9a08de1664583ae14fcb4778cc0bb3e3ab171dd98fca1ee990b74"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11 if OS.linux?

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_OPENMP=OFF", *std_cmake_args
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
