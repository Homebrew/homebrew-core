class Libcec < Formula
  desc "Control devices with TV remote control and HDMI cabling"
  homepage "https://libcec.pulse-eight.com/"
  url "https://github.com/Pulse-Eight/libcec/archive/refs/tags/libcec-8.0.0.tar.gz"
  sha256 "fbbda7e659e5f0b0971fa42a0a42c95f893f602aaf5c0043077a91476bb90b7b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "abdca82c05430382ab347b613cd4198348806d60160a4daa8ed11df17216291b"
    sha256 cellar: :any, arm64_sequoia: "38be569840da977359cdccc8ab17c307c3196e66f7849d2401288504face895a"
    sha256 cellar: :any, arm64_sonoma:  "d81b238c23823b14d4f2e00f4a7abcd30f3c92596fbc8dfd54a634ecb8b9bb9b"
    sha256 cellar: :any, sonoma:        "b32e450a6cea1c3efb5da63fa26ad4782e441fc2927d98d55edfe974d9f0837f"
    sha256 cellar: :any, arm64_linux:   "b3db89a213578164329c38e0c0e73ed189abfacb66fe07e2be88fb2837b961f1"
    sha256 cellar: :any, x86_64_linux:  "672e59c594b13a00a30ec097fd09fac22c015144ed49fa88b25659cab8c59af3"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "libCEC version: #{version}", shell_output("#{bin}/cec-client --list-devices")
  end
end
