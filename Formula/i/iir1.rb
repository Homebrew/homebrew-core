class Iir1 < Formula
  desc "DSP IIR realtime filter library written in C++"
  homepage "https://berndporr.github.io/iir1/"
  url "https://github.com/berndporr/iir1/archive/refs/tags/1.11.1.tar.gz"
  sha256 "ee3ffd1c8b7d406cd5610d537a9e033d93e00f5db208ea0341f0dbd0472e486a"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fb1447fc77cd41cd22080c4b3cbaea302319df9cd2ca86b84fdae381a6cb8a8b"
    sha256 cellar: :any, arm64_tahoe:       "2dd89ed006de829e65d26195f19f1d9a2e7a68bcd052789c963f0d9f92d52946"
    sha256 cellar: :any, arm64_sequoia:     "c7364004c8cfb3e774dd350005cad09020123b4e31710eb1c0b2a1fa7f6690e5"
    sha256 cellar: :any, arm64_linux:       "76b6fc1a45e0963f1c5bcdae2eb445baf60d8249d6272012318364159a325813"
    sha256 cellar: :any, x86_64_linux:      "0e462e7b0cb0dc9b0d5e58c5271e0f0f1f3f6d2b26e5129df3332c7d6dff80c2"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"test").install "test/assert_print.h", "test/butterworth.cpp", "test/scipy.cpp",
                              "test/scipy.h", "test/signal.csv", *Dir["test/butterworth-*.csv"]
  end

  test do
    cp (pkgshare/"test").children, testpath
    system ENV.cxx, "-std=c++11", "butterworth.cpp", "scipy.cpp", "-o", "test", "-L#{lib}", "-liir"
    system "./test"
  end
end
