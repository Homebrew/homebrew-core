class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.1.1.tar.gz"
  sha256 "3ddb7f39863389816f6289f5da2fe921d0d4efe85dcf349fae3a2718cc14f0fb"

  bottle do
    cellar :any
    sha256 "01cebcb9d380b19863a55799d1d6639da3de35d7268a4f51dd60aefc26980c26" => :mojave
    sha256 "0c4a1f1d36005c0f137a368d407c8b8d2c9d06c14753ab2f139c1891fc6bd08b" => :high_sierra
    sha256 "40623dd49ad45063e21f3928f3efcfb16ad17c523e2cf272d489faf2e20b4062" => :sierra
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
