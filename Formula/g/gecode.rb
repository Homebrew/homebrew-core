class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.dev/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.5.0.tar.gz"
  sha256 "83d854613d356da9bc040864479e98d81d090087366219aa23832375a965d64a"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c4f0d6981bf2aecf9d46a19e647e0a95c9ddfd7857356a25d30927f076057225"
    sha256 cellar: :any, arm64_tahoe:       "5fca902a52127fa46dcc4fcce8e204905b80d40801b9baf8167fd6f92ef2e8cf"
    sha256 cellar: :any, arm64_sequoia:     "05345a73605109e672e866d924c7bdce16aef198681babbcc0845d10489c862b"
    sha256 cellar: :any, arm64_linux:       "e63f4683937e62b07340af8be98367e4cfa4821110d6c675c63ffde3819ae0ea"
    sha256 cellar: :any, x86_64_linux:      "07dd9d020ca0d3d307680514295a36a9d28b82dd2bb9cbfb880896db150cb495"
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
