class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.9.4.tar.gz"
  sha256 "67d0982356f33fd37522e4711cda12f70a981a9c83de332386f89de3d7601d2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ecc435c8072c50ebca6f006c2ccaea6cfedd74d57132ad952416509c1016ac7"
    sha256 cellar: :any,                 arm64_monterey: "3d66f65cf388610c99474b0fc3290a593a60ad447ba78e6cd257cd261cbb05e1"
    sha256 cellar: :any,                 arm64_big_sur:  "8a5984cf2aed5419275bec146f4b93933a4ae76ec405d34a2b7c14a2d9597f4d"
    sha256 cellar: :any,                 ventura:        "931c8a3f6ae7b8a167d96c34346fe3c9970ab2a0f765c6ace073b3e43e793f0f"
    sha256 cellar: :any,                 monterey:       "8da5090cc2d37592a01a506505a4dac96e3707887420eea7aa87a02bb975caf3"
    sha256 cellar: :any,                 big_sur:        "563a1e61b5fdb242503946c5acf9d1913ed3a3b32cd776fe9ab3bc7b7bac15a1"
    sha256 cellar: :any,                 catalina:       "37c82c78dcedaa8b7a1da36dba30839497e9681a701fccc30f4393aa56aea782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4808946fad26061995f66f4f4984473671cea831224af146f2c067b4013c243e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/butterworth.cpp", "test/assert_print.h"
  end

  test do
    cp (pkgshare/"test").children, testpath
    system ENV.cxx, "-std=c++11", "butterworth.cpp", "-o", "test", "-L#{lib}", "-liir"
    system "./test"
  end
end
