class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "ca965f933c52a2a9dbb318df4d4de70fac5f095a8e64523f81036ab467a4b567"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "5fcb0ca1f40b157a892db1b780e1b10f24d9d082e45465ff03c5fabf034681b6"
    sha256 arm64_sequoia: "8614fcca0f77cd93f87960c5c28ef0caeb0abce7147534155e8fa67d23c5fb75"
    sha256 arm64_sonoma:  "3d74847d2cfcf600f3b8ae60551a4e769b8208a19f4d3da62546cc435d2cfb33"
    sha256 sonoma:        "34caa66947e3bc29f8cd47266d2cbac8ec12ee1fd8090c55eda4663f87e57439"
    sha256 arm64_linux:   "c779c9691fc3917e44f149774edd4ae4573cebe4fa75d4fbf009719b295f1bc8"
    sha256 x86_64_linux:  "89ec85a2ce8460887a33d687fe685f9d2e7c3500a7c3710dbfa6b80cbe347e93"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libftdi"
  depends_on "libusb"

  on_linux do
    depends_on "systemd"
    depends_on "zlib-ng-compat"
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
