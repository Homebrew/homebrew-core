class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/release-6.1.1.tar.gz"
  sha256 "093e9fc6e5efa47341ec777af3550ded5c25542389d1f35b1dad58179c03cb92"

  bottle do
    cellar :any
    sha256 "55dc34638cfe4faff6aad6557f8e1b17260b1cad6dbd3961acccd118cc84cc89" => :mojave
    sha256 "9122a38fc2a9f87303785b73c9a74237c6f990e9e53804cbf88c84e970689c09" => :high_sierra
    sha256 "42080622f8be3f4168089faccc155d26786e3bc52b9e427c1239bfb35e135e52" => :sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
      --disable-qt
    ]
    ENV.cxx11
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gecode/driver.hh>
      #include <gecode/int.hh>
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
        opt.parse(argc, argv);
        Script::run<Test, DFS, Options>(opt);
        return 0;
      }
    EOS

    args = %W[
      -std=c++11
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -L#{lib}
      -o test
    ]
    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
