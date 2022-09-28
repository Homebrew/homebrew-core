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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "b3ba59f1f821ffd6b073b24aa1a0c2afcd32cd70ec26959e98fe438626e9732a"
    sha256 cellar: :any,                 arm64_big_sur:  "98ba4534124ee1b466109ebd4eb59064357edc3094d1cbd7339b3da874b12a9e"
    sha256 cellar: :any,                 monterey:       "5b0c94a2aa704ef61a443ca0b0750a26980e627b69babcf337c73409d6132364"
    sha256 cellar: :any,                 big_sur:        "88810a46fa5631d6bc10262ad334dc6039c93045442836fc690b2dc277513690"
    sha256 cellar: :any,                 catalina:       "a7f09cd317d3bf0bb3993ce46cfe862d92427aedce3c1a68ca60dd3954ae7475"
    sha256 cellar: :any,                 mojave:         "29c47e508a3e39bce6891219f6ad223b8d8579bd1554ce1382b7dfe3e370e139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1af7280eaec10e6a5e335326793ca36e36e8b41e507ea891ff3bbfdb3d453d01"
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
