class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.9.3.tar.gz"
  sha256 "de241ef7a3e5ae8e1309846fe820a2e18978aa3df3922bd83c2d75a0fcf4e78f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d66f65cf388610c99474b0fc3290a593a60ad447ba78e6cd257cd261cbb05e1"
    sha256 cellar: :any,                 arm64_big_sur:  "8a5984cf2aed5419275bec146f4b93933a4ae76ec405d34a2b7c14a2d9597f4d"
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
