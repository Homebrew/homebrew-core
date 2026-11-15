class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "b62bcfce58dadacece78d140c0b2f0e2c255408c96cb95d23f01ea5b7eea1970"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "35e618b7a630394fa473f08075790985ad00f14dd059af9df2aac93417871248"
    sha256 cellar: :any, arm64_tahoe:       "81548097ee34e140208c725c10b40a03a1990054f5cfd14c58b275c8e7cc296e"
    sha256 cellar: :any, arm64_sequoia:     "f828804240965d31b766693a5a424a614f53b6455b1e4ab4d418f50251fe00f8"
    sha256 cellar: :any, arm64_linux:       "83129daa93c0d2d60e22c3bedcfd0c7ebaf9be441bda0854ce0910f1602b852f"
    sha256 cellar: :any, x86_64_linux:      "cbbaf4d8d37e5ace48554a44968b7ca41a02781e4efa8a5943f0b90c309ac0fe"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => [:build, :test]

  deny_network_access!

  def install
    # Avoid building Linux bottle with `-march=native`. Need to enable SSE4.1 for _mm_dp_pd
    # Issue ref: https://github.com/beagle-dev/beagle-lib/issues/189
    inreplace "CMakeLists.txt", "-march=native", "-msse4.1" if OS.linux? && build.bottle?

    ENV["JAVA_HOME"] = Language::Java.java_home
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/tinytest/tinytest.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"tinytest.cpp", "-o", "test", "-I#{include}/libhmsbeagle-1", "-L#{lib}", "-lhmsbeagle"
    assert_match "sumLogL = -1498.", shell_output("./test")

    (testpath/"T.java").write <<~JAVA
      class T {
        static { System.loadLibrary("hmsbeagle-jni"); }
        public static void main(String[] args) {}
      }
    JAVA
    system formula_opt_bin("openjdk")/"javac", "T.java"
    system formula_opt_bin("openjdk")/"java", "-Djava.library.path=#{lib}", "T"
  end
end
