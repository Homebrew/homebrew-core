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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "ca4a6d6a63718cbfffbc3d4f4729bd0dac761e12d5249bb69dd4cc9336af12c7"
    sha256 cellar: :any,                 arm64_monterey: "ce5c2677ecdb6a2969889eb4540188d2011c11d89254377357b798650e306d58"
    sha256 cellar: :any,                 arm64_big_sur:  "718a01898aefd3ae1bfdb855d15e2181b2391c30aa7ae657696caaab64481013"
    sha256 cellar: :any,                 ventura:        "fd6f151f516ea25e41988a4f84d504e058d9bb176a4d0a286ae9a961229eb0d9"
    sha256 cellar: :any,                 monterey:       "58819eab7ee85c4ef9a5d387e49b9a71f4ed7af37e89fae1b3671277f62a4ded"
    sha256 cellar: :any,                 big_sur:        "ad1826295881c322d817c4be45da9bc16d8e9e60908aa5f01cad8e6cc023c120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c43b06552d98d1890569bd221710face4cf9301336ee0ecd2f612ec8831ee9e"
  end

  depends_on "cmake" => :build
  depends_on "openjdk@11" => [:build, :test]

  # Reinstate versioning for libhmsbeagle. Remove in the next release
  patch do
    url "https://github.com/beagle-dev/beagle-lib/commit/2af91163d48bed8edfbf64af46d5877305546fd1.patch?full_index=1"
    sha256 "2b16b2441083890bacb85ed082b3a7667a83621564b30a132b7ba8538f7d1d6f"
  end

  def install
    # Avoid building Linux bottle with `-march=native`. Need to enable SSE4.1 for _mm_dp_pd
    # Issue ref: https://github.com/beagle-dev/beagle-lib/issues/189
    inreplace "CMakeLists.txt", "-march=native", "-msse4.1" if OS.linux? && build.bottle?

    ENV["JAVA_HOME"] = Language::Java.java_home("11")
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
    system ENV.cxx, "-I#{include}/libhmsbeagle-1", testpath/"test.cpp", "-o", "test"
    system "./test"
    system Formula["openjdk@11"].bin/"javac", "T.java"
    system Formula["openjdk@11"].bin/"java", "-Djava.library.path=#{lib}", "T"
  end
end
