class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.1.2.tar.gz"
  sha256 "dd872b484a3a9f0bce369465e60ccf4e4c0cd7bd5ce41499415366019f236275"
  revision 1

  bottle do
    cellar :any
    sha256 "de8fe667e01d1e204c669980753cf9ef84b4d2406ab52c0882d6d9108d2dc7eb" => :catalina
    sha256 "fe9ae7aaa01df98d34b5cbd7dce8abd9ac840f2bb54797851b42a056ee258e01" => :mojave
    sha256 "d2a42acc06fa4bf26c25b4d63a96c0d6bf46f7b1a21bacf91ef70fbff58e77b4" => :high_sierra
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
