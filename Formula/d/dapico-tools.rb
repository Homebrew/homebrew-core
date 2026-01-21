class DapicoTools < Formula
  desc "macOS USB tools for RP2040-based boards"
  homepage "https://github.com/nanoscopic/dapico-tools"
  url "https://github.com/nanoscopic/dapico-tools/archive/refs/tags/0.1.4.tar.gz"
  sha256 "b39fa950f4080d5702ab00bc77ccc3c3ce057dc1b8963a1e3496607f0faccb29"
  license "BSD-3-Clause"
  depends_on "cmake" => :build
  depends_on :macos

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
