class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.dev/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.4.0.tar.gz"
  sha256 "4cc0e4f440f821a643e637801094cd42ccb5946caf5248c905f29f5f3a16f260"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23b12e1d877493ae754f3d70141930bb0e5c1ce5d75cf5b54c3606dce464d316"
    sha256 cellar: :any, arm64_sequoia: "91d7a03c1ca180a5585ee2ad5e7494b6012c5c1b02aa0f35d4d8b0c103b1137c"
    sha256 cellar: :any, arm64_sonoma:  "68968c925bf66bb0d542dddb2550128fa41604ff43a3009f629f11a540fce6b1"
    sha256 cellar: :any, sonoma:        "cff4b6bed88f6ebbb0e518bdc4bc379b3dd29c938bffd69962d6dccb05725f59"
    sha256 cellar: :any, arm64_linux:   "49c7e26b8c74152c60f5b7cc2d1b21000bb64137e57539f17f7cb3e964a3aa92"
    sha256 cellar: :any, x86_64_linux:  "5750be52017bc170d54237ac24e426a5dbb9c23159572d08ec691611474efaec"
  end

  depends_on "uv" => :build
  depends_on "pkgconf" => :test
  depends_on "qtbase"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
      --disable-mpfr
      --enable-qt
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gecode/driver.hh>
      #include <gecode/int.hh>
      #include <QtWidgets/QtWidgets>
      using namespace Gecode;
      class Test : public Script {
      public:
        IntVarArray v;
        Test(const Options& o) : Script(o) {
          v = IntVarArray(*this, 10, 0, 10);
          distinct(*this, v);
          branch(*this, v, INT_VAR_NONE(), INT_VAL_MIN());
        }
        Test(Test& s) : Script(s) {
          v.update(*this, s.v);
        }
        virtual Space* copy() {
          return new Test(*this);
        }
        virtual void print(std::ostream& os) const {
          os << v << std::endl;
        }
      };
      int main(int argc, char* argv[]) {
        Options opt("Test");
        opt.iterations(500);
        Gist::Print<Test> p("Print solution");
        opt.inspect.click(&p);
        opt.parse(argc, argv);
        Script::run<Test, DFS, Options>(opt);
        return 0;
      }
    CPP

    flags = %W[
      -I#{include}
      -L#{lib}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -lgecodegist
    ]
    flags += shell_output("pkgconf --cflags --libs Qt6Widgets").chomp.split

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
