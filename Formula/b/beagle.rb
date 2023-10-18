class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/v4.0.1.tar.gz"
  sha256 "9d258cd9bedd86d7c28b91587acd1132f4e01d4f095c657ad4dc93bd83d4f120"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6d8ccd22a1a3dd0fc66aa753d774382005e10a6c92102af898a8c48a249e2d6"
    sha256 cellar: :any,                 arm64_ventura:  "3d83a1652998bf200c2b1a7942fb3946d751a9d647f46b1275109e49c48be695"
    sha256 cellar: :any,                 arm64_monterey: "8ec46e2c91cff30977deec35fc3e01707f11f81960075c16da25edb8a6f9ca8c"
    sha256 cellar: :any,                 sonoma:         "da4b28f050e38cfafa7cdcfaef9cec21e01f9335a609ea2e415357c8fe901da4"
    sha256 cellar: :any,                 ventura:        "b59a52ec3fac58ea5c9e1b9e9240befe1f3d81fb30803c8c1028047f3d192cdb"
    sha256 cellar: :any,                 monterey:       "ab9a7a95580ffe99fde279ce650f66a39fc3f1065c9cf767feb4b2bec6f71b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8fce3c841addff79fd9d784f923a29b7e5f3549ce75b91c2d895f83542411c"
  end

  depends_on "cmake" => :build
  depends_on "openjdk@11" => [:build, :test]

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
