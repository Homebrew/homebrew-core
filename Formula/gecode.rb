class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "https://www.gecode.org/"
  url "https://github.com/Gecode/gecode/archive/release-6.1.0.tar.gz"
  sha256 "e02e48aa90870a25509de2aeb99662d8b51c1de60cae4a34a78d4b6e9321e7ae"

  bottle do
    cellar :any
    sha256 "2bc4fdd0449bfaa2240096cc0cb4c41410bbd98ca5f5aecd17ad447c75de15e5" => :mojave
    sha256 "429df4b22ad12271341419dc6872e65ffac5b70b9815dd9274914209370c701b" => :high_sierra
    sha256 "a91ba1e8e0ee585a8bea0adbfe4c9242bf30f61bce3cf50a4d0cfff4088b568b" => :sierra
  end

  deprecated_option "with-qt5" => "with-qt"

  depends_on "qt" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
    ]
    ENV.cxx11
    if build.with? "qt"
      args << "--enable-qt"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/opt/qt/lib/pkgconfig"
    else
      args << "--disable-qt"
    end
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
      -I#{HOMEBREW_PREFIX}/opt/qt/include
      -I#{include}
      -lgecodedriver
      -lgecodesearch
      -lgecodeint
      -lgecodekernel
      -lgecodesupport
      -L#{lib}
      -o test
    ]
    args << "-lgecodegist" if build.with? "qt"
    system ENV.cxx, "test.cpp", *args
    assert_match "{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}", shell_output("./test")
  end
end
