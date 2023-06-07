class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.9.4.tar.gz"
  sha256 "67d0982356f33fd37522e4711cda12f70a981a9c83de332386f89de3d7601d2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "511e19fc6d204436638fd7eb94142543cda82c696cba8d2ef91f6a828d55ffef"
    sha256 cellar: :any,                 arm64_monterey: "f865356c4f33bde3c56cc57bc6094d16c8f733fa15f6274e7133b85fb5046b6f"
    sha256 cellar: :any,                 arm64_big_sur:  "d8c9a57a73a2e21cd8ab7d52417695f43e0fd7e0e35565a64110a89b5368a808"
    sha256 cellar: :any,                 ventura:        "45476c001331f95dc7cb51848f24d411e745a52729e467f27ec3ec957f842897"
    sha256 cellar: :any,                 monterey:       "b1aa46449591c4faf5a33de5cda71f5561794080fa1514cf5064efd248c059c5"
    sha256 cellar: :any,                 big_sur:        "8abc8c8f703c81ca101ea20f36f2612279b9b5cf8e1f1642ce56dd4bb0a3a827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b019772e5d336dac298e7380cbd611f5d7dc5cd02a22673717f656c8e94b0f96"
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
