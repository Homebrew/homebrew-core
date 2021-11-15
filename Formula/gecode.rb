class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/release-6.2.0.tar.gz"
  sha256 "27d91721a690db1e96fa9bb97cec0d73a937e9dc8062c3327f8a4ccb08e951fd"
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/Gecode/gecode"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f3cdbbfb25adcd0da1e9c5c41f3e5dec376b11925637c32aa107804697587842"
    sha256 cellar: :any,                 arm64_big_sur:  "e0f6097e794cc4e9c329707cf95f23ff9dae359cae580f5dbb3024eb7d4d6053"
    sha256 cellar: :any,                 big_sur:        "c3f810ac6de7a14b4822df9605150d209ec30b19635e0ee76447f36837e68d0c"
    sha256 cellar: :any,                 catalina:       "aefca2af2ff839b0089eb1cb82cb77351ccd8edfb89a43231b9f33faf5e35fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1527a7288d9563ccb403b3b9a7bf42fec644efa476661d36d3c36a05aed017"
  end

  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
      --enable-qt
    ]
    ENV.cxx11
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    args = %W[
      -std=c++11
      -fPIC
      -I#{Formula["qt@5"].opt_include}
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -lgecodegist
      -L#{lib}
      -o test
    ]
    if OS.linux?
      args += %W[
        -lQt5Core
        -lQt5Gui
        -lQt5Widgets
        -lQt5PrintSupport
        -L#{Formula["qt@5"].opt_lib}
      ]
      ENV.append_path "LD_LIBRARY_PATH", Formula["qt@5"].opt_lib
    end

    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
