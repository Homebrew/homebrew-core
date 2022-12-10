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
    sha256 cellar: :any,                 arm64_ventura:  "bba13ae084772efb7e685d560fa444e1395dc8dbb3e60a87a1d3ad038bb13ef0"
    sha256 cellar: :any,                 arm64_monterey: "d39a3c6afff8db4d34dd5a0e4358793f29aa8c27b0324aaa320ded3ba220f133"
    sha256 cellar: :any,                 arm64_big_sur:  "b9f67e5318b50445e3d793184750c99a92f746f832f4daff24136f12b33e2172"
    sha256 cellar: :any,                 ventura:        "d6f56b3a1962718a8d6fc2a3a0f02839a72099ff8e18b3670ac3d7377fa07f25"
    sha256 cellar: :any,                 monterey:       "080d59dfd1136c9de6816f1c165e4f5889fe5d2177fa6f6f43d27374c285410f"
    sha256 cellar: :any,                 big_sur:        "402bc5f510cceb63134695fd4a4727dd4b09dded8c9fb1f77309372940e6b378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa2a615224e3cfc0a53fb67a6dbc292b0fb5f766103703ddf4ed0c24c9551be"
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
