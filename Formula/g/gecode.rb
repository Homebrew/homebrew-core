class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.dev/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.3.0.tar.gz"
  sha256 "e3b5d9051bbc669ac39344adaa208ccb0b340213f4e03dec12c7bfb96ab8673d"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "4bf3ed46450a9a436678fcf7bc2083d7ba8c9b4847e3846fa66b50423c4e273d"
    sha256 cellar: :any,                 arm64_sequoia: "fcd5d80e9d1d6fada71c424647c5be7ed126831b83d57deece2b836fa44dfe58"
    sha256 cellar: :any,                 arm64_sonoma:  "b7653b544c06145b4a39d83311a0583849d4d4cf2873b81c341cddd135bed39f"
    sha256 cellar: :any,                 sonoma:        "313e206a83f8a8459519f23e0c1d6e96978791ec62b162118aa7f036204615e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0762e8669a3b0aff790ec8673ca1fc8dda25b741368d289c3c3cc5c2d559c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "829f38b21be0258bcc84402afb8b7cefa9272a8a59e36f94aee33b7d8ace7ac4"
  end

  depends_on "pkgconf" => :test
  depends_on "qtbase"

  def install
    ENV["MOC"] = Formula["qtbase"].opt_share/"qt/libexec/moc"
    ENV.append "CXXFLAGS", "-std=c++17"

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
