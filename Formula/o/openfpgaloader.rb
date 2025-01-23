class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "372f1942dec8a088bc7475f94ccf5a86264cb74e9154d8a162b8d4d26d3971e3"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3d2834dbd959beb410e957fe036b89061ed6c3917f5bc95aa095263a7fde0441"
    sha256 arm64_sonoma:  "adecca7a524b314f0783020843c1e243556ad09725ad61173a67b51746969201"
    sha256 arm64_ventura: "f5bf61cadaa7161e3c3620406c446e0b4fe3774738b8ee85e96e36c3f754fd4e"
    sha256 sonoma:        "c6c284837966c0bbf5bffee515c6f1f9d82f9c3833e9bee7897fa9f54d80ce25"
    sha256 ventura:       "b999c7d101214bbcf8948d2692f00d0d0c53f654f870ea321e7105fb317dd4db"
    sha256 x86_64_linux:  "16261ec88867b7acb11f2f4d9fcd0bdd008c5152d2aee7a81282a4e8d1a1a6bf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd"
  end

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
