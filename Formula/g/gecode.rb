class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.dev/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.4.0.tar.gz"
  sha256 "4cc0e4f440f821a643e637801094cd42ccb5946caf5248c905f29f5f3a16f260"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "c1af270f7d409a951da92ca72fd36b6ef1e9e93309436bfe4d48abdb19ca4348"
    sha256 cellar: :any, arm64_sequoia: "9baaf5b2e7a92df403a8803df2b1f5af30167af6e05b1e2ca203237ef785c35e"
    sha256 cellar: :any, arm64_sonoma:  "09c9a1c1cab4871e9d4579977f2d4cf223eeed16852a1df8d690c49a0784fe32"
    sha256 cellar: :any, sonoma:        "f6f9fad598c2f3cc07dcc313fa2f35512cabd848bd32a52bfc1ee5bd7bdb229f"
    sha256 cellar: :any, arm64_linux:   "7c006d234dfec33ffd670506904609655a71cb822be8fb05e1eb2ac917551477"
    sha256 cellar: :any, x86_64_linux:  "177253ab8d6c6374ca31dc7d77d979784e256f9b8985f38110e120d41a2b1bee"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "qtbase"

  def install
    args = %w[
      -DGECODE_ENABLE_EXAMPLES=OFF
      -DGECODE_ENABLE_GIST=ON
      -DGECODE_ENABLE_MPFR=OFF
      -DGECODE_ENABLE_QT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
