class Beagle < Formula
  desc "Evaluate the likelihood of sequence evolution on trees"
  homepage "https://github.com/beagle-dev/beagle-lib"
  url "https://github.com/beagle-dev/beagle-lib/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "9d258cd9bedd86d7c28b91587acd1132f4e01d4f095c657ad4dc93bd83d4f120"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bc8e56cab2d1da3a82d01ba8a9e1b3976213a155667eec3e8a3ece160c0344fc"
    sha256 cellar: :any,                 arm64_sequoia: "fe362a0f25bf169bb507df13e17e4647a85b185383308fa2c6907bf57a0c3bc9"
    sha256 cellar: :any,                 arm64_sonoma:  "a15730feb6101837d824ccc36397e4f777e450312e3e142b5e0a4752f44cfb4b"
    sha256 cellar: :any,                 arm64_ventura: "630068ff93debb8af7e06748abb07dc1637467795b01bbd04aca01212a23c683"
    sha256 cellar: :any,                 sonoma:        "1a82a444e21aaf6ed87d13d100fe09bf5dada1f97794a349cb66e429d35ed7dd"
    sha256 cellar: :any,                 ventura:       "a249e59ce098ccab24c15b794bcd148dca578ce4cb5aad253732c8e9466c7f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a23bc6a7ade9eaeda9911a39a644a45f081f215b080de725a322dabf2b803063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc0660f81935172863061b141e4576bedc36db62b6b0c0b7f5bececc5ed40689"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => [:build, :test]

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
    if OS.mac? && Hardware::CPU.arm? && Hardware::CPU.virtualized?
      # OpenCL is not supported on virtualized arm64 macOS which breaks all Beagle functionality
      (testpath/"test.cpp").write <<~CPP
        #include <iostream>
        #include "libhmsbeagle/beagle.h"
        int main() {
          std::cout << beagleGetVersion();
          return 0;
        }
      CPP
      system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}/libhmsbeagle-1", "-L#{lib}", "-lhmsbeagle"
      assert_match version.to_s, shell_output("./test")
    else
      system ENV.cxx, pkgshare/"tinytest.cpp", "-o", "test", "-I#{include}/libhmsbeagle-1", "-L#{lib}", "-lhmsbeagle"
      assert_match "sumLogL = -1498.", shell_output("./test")
    end

    (testpath/"T.java").write <<~JAVA
      class T {
        static { System.loadLibrary("hmsbeagle-jni"); }
        public static void main(String[] args) {}
      }
    JAVA
    system Formula["openjdk"].bin/"javac", "T.java"
    system Formula["openjdk"].bin/"java", "-Djava.library.path=#{lib}", "T"
  end
end
