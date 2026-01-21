class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/refs/tags/release-6.2.0.tar.gz"
  sha256 "27d91721a690db1e96fa9bb97cec0d73a937e9dc8062c3327f8a4ccb08e951fd"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

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

  # Backport support for Qt6 from release/6.3.0 branch
  patch do
    url "https://github.com/Gecode/gecode/commit/c0ca0e5f4406099be22f87236ea8547c2f31ded3.patch?full_index=1"
    sha256 "233b266a943c0619b027b4cb19912e2a8c9d1f8e4323a3627765cb32b47c59fe"
  end

  def install
    # Backport parts of upstream commit[^1] and add workarounds to allow configure to build with Qt6
    #
    # [^1]: https://github.com/Gecode/gecode/commit/19b9ec3b938f52f5ef5feef15c6be417b5b27e36
    inreplace "configure", "if test ${ac_gecode_qt_major} -eq 5;", "if test ${ac_gecode_qt_major} -ge 5;"
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
