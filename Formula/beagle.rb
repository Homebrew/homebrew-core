class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v4.0.0.tar.gz"
  sha256 "d197eeb7fe5879dfbae789c459bcc901cb04d52c9cf5ef14fb07ff7a6b74560b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "417d70e5874ea00a8eb1487ee490e8420599b5a6c8bd9f949b8fa296ade5df11"
    sha256 cellar: :any,                 arm64_big_sur:  "1ea7c6f271742ecabc2b102d698bc4e65b5ab11e4445dc4829aa8cfc54c68d02"
    sha256 cellar: :any,                 monterey:       "69a5e140d59bf732b928b6af01cb3ac153e4a7f841b47035edae263874abcad2"
    sha256 cellar: :any,                 big_sur:        "ba32a1ab7c5f5d8d0b1c595e072b40cf4d4c744a946f388850834ce5a58304c2"
    sha256 cellar: :any,                 catalina:       "858b9d97f17461ee0ba5111753c8d057d598d088566a247d0a4bb1fe2d3a2cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f89845cd5fabec607b9c2c3d648142a85bae3853609c38dc23930e3532b7336"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => [:build, :test]

  # Reinstate versioning for libhmsbeagle. Remove in the next release
  patch do
    url "https://github.com/beagle-dev/beagle-lib/commit/2af91163d48bed8edfbf64af46d5877305546fd1.patch?full_index=1"
    sha256 "2b16b2441083890bacb85ed082b3a7667a83621564b30a132b7ba8538f7d1d6f"
  end

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
