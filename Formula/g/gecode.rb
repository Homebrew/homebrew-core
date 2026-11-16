class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.dev/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.6.0.tar.gz"
  sha256 "de6441af2495aeb2b48766caaf51858ece69acf73cab3c39a96341f5b816a564"
  license "MIT"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c4795b63e941c436ca04e3090712ab4eaaefa212040aeba8db69bfaf45122b4"
    sha256 cellar: :any, arm64_tahoe:       "bde444a2c5b50ec670ac2e81746fd12bdd072d1e6c715ad1f3274d01d6520272"
    sha256 cellar: :any, arm64_sequoia:     "724e2dac5168efb3fb9a6f52a9bbd70fc33426d17f97a1eaee2f02969b741eb4"
    sha256 cellar: :any, arm64_linux:       "22282dc5f717b9ebe74e183ab7c78f57fe6383e392e285b18efe99bc51dce6ce"
    sha256 cellar: :any, x86_64_linux:      "5a0afbeb172c5cb9559d1c9a73b2939053580f553bb2c2c96cc4f68a0ce6f16c"
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
