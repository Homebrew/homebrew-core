class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.11.0.tar.gz"
  sha256 "a463690358d2510919472c2f460039a304d016a08a45970821e667eea1c48cc8"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "666c9c4f7c003395fda0e142c59edcb600ea189decb7575f5f166b711192c019"
    sha256 arm64_monterey: "4aef28949c50535a09557216b0f5849888cdb24f7774e0b4a0702f410880e6b8"
    sha256 arm64_big_sur:  "17e1f7ac035a755119d64b779b53bf54ce6d6035eb2f6c4f405a9d41f3158bcb"
    sha256 ventura:        "835de1449778a19b0673c12e4f1f1375e02b43223228cbfe89e86cef0500d043"
    sha256 monterey:       "981717b4fdd06ff7a17b6425c9d03af29ecb003239e25c70646e15f4948843a6"
    sha256 big_sur:        "178c65d1afa79644bfbea2effbc3f0d3570ada4b8ceb1aaae5a00605f651cf48"
    sha256 x86_64_linux:   "3f010d95399d2a150706ee2176bcc1b651f229e556d1fac89f7f70246aa84944"
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
