class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.2.0.tar.gz"
  sha256 "27d91721a690db1e96fa9bb97cec0d73a937e9dc8062c3327f8a4ccb08e951fd"
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/Gecode/gecode"
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "884ec5f071d961e87c4d6200ea3f81e7452066cca47c226f649ca4b9cf12f5f0"
    sha256 cellar: :any,                 arm64_sonoma:   "fe7f8c7a62e4d933818fbf4a10c69ca85285639c8f362b7d8021c3d7516dfc92"
    sha256 cellar: :any,                 arm64_ventura:  "d4034d14e93b5320709f5935ab5c338aa8944d6969a5641ac54533a38aec807d"
    sha256 cellar: :any,                 arm64_monterey: "3d84e1de9c817d479b07246fe62a5496d59f236f04e10c20b435ebab144a26c0"
    sha256 cellar: :any,                 arm64_big_sur:  "b1d5780bc5589bb71c73a14555df6fdb18ad4ae9f0a19a4741e4e687c15eaf4d"
    sha256 cellar: :any,                 sonoma:         "0437629c9b922293f72705339f617324024d98ec8d82a09466b17e1a0086281f"
    sha256 cellar: :any,                 ventura:        "fd1dbd0150d87c2f9362d9283d4ef65fb3fd5366e4386cac6d226b5b26e91ac9"
    sha256 cellar: :any,                 monterey:       "13ce2759de416899038a4dbfd2c336ca30d09a4fe3fb3521d008bca1dcc277ab"
    sha256 cellar: :any,                 big_sur:        "3d08807bdd49d5078706ca78b108a276d55a4e6e74b0478ce5b8579f8610e36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65740a01de43a11491d8f6eefb60bf20670fa9e1d15ad8d79209324bb424a3fb"
  end

  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
      --disable-mpfr
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
