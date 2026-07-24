class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.1.0.tar.gz"
  sha256 "11fef68e5a77adf30519096c333d4cdb3f4cfd1d9e0a6d679636899c5807f585"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8df50d2b4ae218661eb297d51dd67494dcbab5f0c79ff0c628ca27615bed2a35"
    sha256 cellar: :any, arm64_sequoia: "0fe31286e1ee21ad365817c96f52abdfc8b10ab94d4725fc55d194f0205982fd"
    sha256 cellar: :any, arm64_sonoma:  "38e3ff08f1cc8532e1b1d8d9118fcf67b8709cc09f666f7902842468a0436660"
    sha256 cellar: :any, sonoma:        "49601b83a4e2b63eece3c49b643d0cf54c7f1b16ca95f45c7bba5ccce6994269"
    sha256 cellar: :any, arm64_linux:   "e29af667948ce5aeaa077f3176a305df56996c64c87ac843abf2042665b35b33"
    sha256 cellar: :any, x86_64_linux:  "c4df4c9c35a1a88627ed35be53fd3ba6dd3c813491d5205b744ae43c1438d909"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end
