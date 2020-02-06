class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.1.2.tar.gz"
  sha256 "dd872b484a3a9f0bce369465e60ccf4e4c0cd7bd5ce41499415366019f236275"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "e3a8d1dae20da88139fceb606df94812e293024b8108222f762867ea6a64aafe" => :catalina
    sha256 "9ee0e3619b1aa655a6a6daf9ee2fa3d7b37098eacfb6e50214062b8c1989420b" => :mojave
    sha256 "2fa7d02be8cf19fa4b0344e2d4c920ec49981c39c7a60938a5c124ce601080e6" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "openjdk" => [:build, :test]

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
    system "#{Formula["openjdk"].bin}/javac", "T.java"
    system "#{Formula["openjdk"].bin}/java", "-Djava.library.path=#{lib}", "T"
  end
end
