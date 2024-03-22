class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "4c087f5c2510b8d5307b82eb85e621a699e6aa89505734fa1d5447d64473294e"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "e01a215c16c41140fcbda7940a95cefdcdd7fdc941390238fbaf6f842c8a766a"
    sha256 arm64_ventura:  "7ea2d9905a30cdb7e3300b33a2e3284cbdc72f4a844a027dac37f20488ca4120"
    sha256 arm64_monterey: "83e2cd627e0bec7218c3d02f65c70e72f96deeffd01a651be8fe8dc1c8e0a2e3"
    sha256 sonoma:         "99fea384a000bf86855732b406ff2fdee7cba5ed2a04508b5fb8efa9a66f373c"
    sha256 ventura:        "0603023f401d5d8fefd723f9fc15a4cb5fe28236a418d8ddf6213fb088b60383"
    sha256 monterey:       "4abe25c4379a4c5088456799e742b1d5e07f6701eb2e298361c32dd7934a9947"
    sha256 x86_64_linux:   "dcad59c7d6df1562f7d9d8c183e0dcd74f10d20d24d01ac945b988ae4d02e3f7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    version_output = shell_output("#{bin}/openFPGALoader -V 2>&1")
    assert_match "openFPGALoader v#{version}", version_output

    error_output = shell_output("#{bin}/openFPGALoader --detect 2>&1 >/dev/null", 1)
    assert_includes error_output, "JTAG init failed"
  end
end
