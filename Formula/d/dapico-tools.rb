class DapicoTools < Formula
  desc "macOS USB tools for RP2040-based boards"
  homepage "https://github.com/nanoscopic/dapico-tools"
  url "https://github.com/nanoscopic/dapico-tools/archive/refs/tags/0.1.3.tar.gz"
  sha256 "c62a03f757839298d9d8136393217b667e9909ec88c065b3d2bfcc09517f71a1"
  license "BSD-3-Clause"
  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/dapico-reboot", "--help"
    system "#{bin}/dapico-load", "--help"
  end
end
