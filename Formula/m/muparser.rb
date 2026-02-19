class Muparser < Formula
  desc "C++ math expression parser library"
  homepage "https://github.com/beltoforion/muparser"
  url "https://github.com/beltoforion/muparser/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "20b43cc68c655665db83711906f01b20c51909368973116dfc8d7b3c4ddb5dd4"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/beltoforion/muparser.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "23a51e97ef3d4ff02c8d8d6fb5dd53b142e89899927a9204eb4dd0018d21afe5"
    sha256 cellar: :any,                 arm64_sequoia: "533245424ca9045f9e246b1c2092466b11b26fb13545b19d82469c8fd36eb2c6"
    sha256 cellar: :any,                 arm64_sonoma:  "6e95b519ddaac7419352a19803d374262d8edf9780e942b287046be0e2e5c9c5"
    sha256 cellar: :any,                 sonoma:        "62577464227b08a4c38a09c93f7438e21c55cd3438fdf67f227ee6bc5c2a51ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9b39ed5b616e3f67f8429a33ed9c42b3f404c74881c4718e4f12444153611ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7935fbf6a0c3698082df30fb1b5e7140e45c9b98d16377810efd80585691d5"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  link_overwrite "lib/libmuparser.dylib", "lib/libmuparser.2.dylib"

  def install
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
