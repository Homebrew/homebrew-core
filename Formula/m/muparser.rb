class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9dd0fef93be805c1e9d38e0a65f780482e4f31600e2ca06de03117961482515"
    sha256 cellar: :any,                 arm64_sonoma:  "45cdabf66b22739dc8e558b062cc6a1f330d38d0ec7400c0ba0399f4b70f8d18"
    sha256 cellar: :any,                 arm64_ventura: "0e8b448240be0fc032dee25dae2d40a7d4c143b7acbabd7abfce2f066e09da24"
    sha256 cellar: :any,                 sonoma:        "bb235a4e1df126fe983925b4debd0b971abab5d2d588d1184fa55cef232b7eef"
    sha256 cellar: :any,                 ventura:       "a17fbefec1301c80a8ff8f5d1fece66401a4e959c6f9aded0290f51cf31edede"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d3d3f6acf9815f9e2c3bb3210ea66d744f88d72a75a70e9a3214bafb8306f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "531bcd3892d0938e5fd2b8e174be8a0ddb75183601bea0a31199bfdeabbf822a"
  end

  depends_on "cmake" => :build

  on_macos do
    conflicts_with "gromacs", because: "gromacs ships its own copy of muparser"
  end

  def install
    ENV.cxx11 if OS.linux?

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_OPENMP=#{OS.mac? ? "OFF" : "ON"}", *std_cmake_args
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
