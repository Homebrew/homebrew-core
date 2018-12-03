class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.1.2.tar.gz"
  sha256 "dd872b484a3a9f0bce369465e60ccf4e4c0cd7bd5ce41499415366019f236275"

  bottle do
    cellar :any
    sha256 "032c922981ee1707934cceb53318a26dab4a0ca6c392db63115f626a9f56b412" => :mojave
    sha256 "d7834048b8aabdedcc824daf474cefe0436fdd8515da4df3f6c52a87d01395ef" => :high_sierra
    sha256 "87e49bf8faeff280ba1211a7c0a0b1626750652b0498eef2ff01dfcff4290056" => :sierra
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
