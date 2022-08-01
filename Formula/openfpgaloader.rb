class Openfpgaloader < Formula
  desc "Universal utility for programming FPGA"
  homepage "https://github.com/trabucayre/openFPGALoader"
  url "https://github.com/trabucayre/openFPGALoader/archive/v0.9.0.tar.gz"
  sha256 "1555b7ba1eb5f98d4c7a0d77c1ed7ab54214e942b8c562264e74b5d3997e0dd3"
  license "Apache-2.0"
  head "https://github.com/trabucayre/openFPGALoader.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f15c29ab551bbc53362ee15524d665fd03576acd28e1db3e3aae300b49a9dbb9"
    sha256 cellar: :any,                 arm64_big_sur:  "cfb608040a77c347e12600bfc9f523f59a6637bf0106c50486ee9ee777ec79fd"
    sha256 cellar: :any,                 monterey:       "2dffd1992ce56cbe5ca65c2e1353f2e554400cb696ae977727881813e60a8a7b"
    sha256 cellar: :any,                 big_sur:        "c894086e3e9fa0ea379208573d958e09b41f23a6680271f8b473c4283ab2edcc"
    sha256 cellar: :any,                 catalina:       "0bf50bbb9b1478fef9ee4902920756965cb9611e451a3ac181bbbf82dbcc8708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f47c7cbfc4fc29340962d13929bdb2460e8ea9f82c7fd3318b214b81c80ac1f"
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
