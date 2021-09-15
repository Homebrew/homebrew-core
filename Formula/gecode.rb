class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/release-6.2.0.tar.gz"
  sha256 "27d91721a690db1e96fa9bb97cec0d73a937e9dc8062c3327f8a4ccb08e951fd"
  license "MIT"

  livecheck do
    url "https://github.com/Gecode/gecode"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b8e2416b133d383ed7e338b98282c4dc4e517fb241c708ec88bdca810d569423"
    sha256 cellar: :any,                 big_sur:       "fc2f5401e3d709dad5bbca740c3c084987c495712990627d213437c94a9c6e97"
    sha256 cellar: :any,                 catalina:      "de386e8ea3dcdbce6d35fe62e0f38f0bf51c6844db35eb7a2f81aa5501fa9c0d"
    sha256 cellar: :any,                 mojave:        "525b7649d716a0ccb5f47f29e93a07f1677cbe531c9c978656b04826ad1cb678"
    sha256 cellar: :any,                 high_sierra:   "763d0d5da64075f5f64c3b7aee49a604680c266b1b6e4eeb8ffcfdb9e0d9ca0d"
    sha256 cellar: :any,                 sierra:        "1bb46e60636f1431cc5bf4b9aed1a2f038da1fef0eaeb1c3130a9252924efd54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f818c76e47ef63048f87fd2b75a6b379eef97b934079a427578c727e2fa21f2"
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
