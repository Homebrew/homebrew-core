class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v3.1.1.tar.gz"
  sha256 "3ddb7f39863389816f6289f5da2fe921d0d4efe85dcf349fae3a2718cc14f0fb"

  bottle do
    cellar :any
    sha256 "5f1ca5d2b95fb7a1873832457baf3f9770bdaf7ec963ca76d18665d55dd2b871" => :mojave
    sha256 "56ecfcd71a3b4ef87d590107e0ae134f13b4dc4bc5336e90e8b13bc3f1cc84ef" => :high_sierra
    sha256 "9f849589808dfc134724f590b32d1fbde770d7a19d600ddf23c59d545188f134" => :sierra
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
