class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "http://www.gecode.org/"
  url "http://www.gecode.org/download/gecode-4.4.0.tar.gz"
  sha256 "b45783cc8d0d5dbbd3385a263a2199e6ad7f9a286e92607de81aa0c1105769cb"

  bottle do
    cellar :any
    sha256 "529db95f87f6f3fa72ffc66c9db7f380f4b904b12ec456e9161134f3b13a5fc7" => :sierra
    sha256 "4aa4d7b036da2e4976b469fc6b7addf44778a24fcc85d9fdec80e50d28dd50c8" => :el_capitan
    sha256 "4df88b3f67a4d188f00883f182f3893b9df99b90637635abf18441ebfbeb0c9c" => :yosemite
    sha256 "b48b0a8755542484f5eeb5647e41db0824cfb769060c28c118df6267fa98aaab" => :mavericks
    sha256 "a6cf500df618c42f0668bb227c090e6c1d3d3369c8b4537220d3deb78d5f8286" => :mountain_lion
  end

  depends_on "qt5" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
    ]
    ENV.cxx11
    if build.with? "qt5"
      args << "--enable-qt"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    else
      args << "--disable-qt"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <gecode/driver.hh>
      #include <gecode/int.hh>
      #if defined(GECODE_HAS_QT) && defined(GECODE_HAS_GIST)
      #include <QtGui/QtGui>
      #if QT_VERSION >= 0x050000
      #include <QtWidgets/QtWidgets>
      #endif
      #endif
      using namespace Gecode;
      class Test : public Script {
      public:
        IntVarArray v;
        Test(const Options& o) : Script(o) {
          v = IntVarArray(*this, 10, 0, 10);
          distinct(*this, v);
          branch(*this, v, INT_VAR_NONE(), INT_VAL_MIN());
        }
        Test(bool share, Test& s) : Script(share, s) {
          v.update(*this, share, s.v);
        }
        virtual Space* copy(bool share) {
          return new Test(share, *this);
        }
        virtual void print(std::ostream& os) const {
          os << v << std::endl;
        }
      };
      int main(int argc, char* argv[]) {
        Options opt("Test");
        opt.iterations(500);
      #if defined(GECODE_HAS_QT) && defined(GECODE_HAS_GIST)
        Gist::Print<Test> p("Print solution");
        opt.inspect.click(&p);
      #endif
        opt.parse(argc, argv);
        Script::run<Test, DFS, Options>(opt);
        return 0;
      }
    EOS

    args = %W[
      -std=c++11
      -I#{HOMEBREW_PREFIX}/opt/qt5/include
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -L#{lib}
      -o test
    ]
    if build.with? "qt5"
      args << "-lgecodegist"
    end
    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
