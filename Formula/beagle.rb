class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.1.0.tar.gz"
  sha256 "f680bdace45dffbb175688aa8bf679710e4e60d000bbf332860de757d4e1c411"

  bottle do
    cellar :any
    sha256 "9b7d3783ddf2ebf6c6fc66593d99f088a1301fc5864ddd8297388f0ef22f82c4" => :mojave
    sha256 "67d0ab1ff1e002ee1e7cd8c2c115e0b99c48f37e3f19f960a172c4ef5ac72689" => :high_sierra
    sha256 "4fa457aa7ce867b6147d07c9a8b1043e69a45cd1f3190566d1697e8acdf08415" => :sierra
    sha256 "9bd4cc062508f497135833251d2e12dca80ed702dcd675e6374719bef33e42e2" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on :java => [:build, :test]
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-cuda",
                          "--disable-libtool-dev"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "libhmsbeagle/platform.h"
      int main() { return 0; }
    EOS
    (testpath/"T.java").write <<~EOS
      class T {
        static { System.loadLibrary("hmsbeagle-jni"); }
        public static void main(String[] args) {}
      }
    EOS
    system ENV.cxx, "-I#{include}/libhmsbeagle-1",
           testpath/"test.cpp", "-o", "test"
    system "./test"
    system "javac", "T.java"
    system "java", "-Djava.library.path=#{lib}", "T"
  end
end
