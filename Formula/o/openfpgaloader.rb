class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://trabucayre.github.io/openFPGALoader/"
  url "https://github.com/trabucayre/openFPGALoader/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f75e9896bd8c6310f98ecd629ed260ecaa83329c31e0f8f831b07531aa64d30a"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "5a9b6f924cbe2768a0dde221bdf79ed470d022154b7f3792d1b62c5e9fd1db16"
    sha256 arm64_tahoe:       "ed2945e869e924658e54682aa59b4da277bf82f4c051a396b66abc4c974cf0df"
    sha256 arm64_sequoia:     "bd2f4c86f02c64db798d79ba1efc49cbaa9725401596d9ba3bffa80d9c02b2d9"
    sha256 arm64_linux:       "e9db39482df82beb0ebbb003b4cdc78f5f579f9e040198dc963e8ecb1f9a9c0c"
    sha256 x86_64_linux:      "96b169928117d591a94c5a78cfd1ddf3e47c665f3a4d2180a9a82c007733af34"
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
