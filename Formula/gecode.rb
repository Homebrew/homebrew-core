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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6fe3d86edd99807461a3f801578240cb787c9ec7b45a311168d2dbfa09354510"
    sha256 cellar: :any,                 arm64_monterey: "5fe08254427f34ce2293d47e86977f618e00683e8ec3b2e99fefd4a2959380a5"
    sha256 cellar: :any,                 arm64_big_sur:  "22eb9f1492c53939827a0ba685c2513b0dfb92eb1aa1f047dc5cb167e5a076c3"
    sha256 cellar: :any,                 ventura:        "b230333cb83baef3a1862d73384fbe2cacc554059353175c22a742ead4a83682"
    sha256 cellar: :any,                 monterey:       "bd26a1a5aee579ab1cbcaecbb9a3a773d6f825830274a1ada1005b46487ba77f"
    sha256 cellar: :any,                 big_sur:        "e51d96cd677b1e4ca64e2f284fa326a1042aa50dcf4330b986dab374cb750c88"
    sha256 cellar: :any,                 catalina:       "260ec66da40aeeda42d43947309fef98b05411f6bc252c5326d43ced0c080e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17892f83854cda9285f077320bd113ad74ec00d750392821b01662dea8f9a0fe"
  end

  depends_on "qt@5"

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
