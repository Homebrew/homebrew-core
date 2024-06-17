class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "1a454b5f72aeda00dbea0ebb89b6ccbd39c681a8c11d80c7278b9e7a3e935319"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad50f43a8dabb91a5ef06a06b80da2f62c90294d3083eec1e5cd0fd2a343451"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a9960544a4f5a8eaf4350b09109cfc07a46e7f687e1b75daadff910c0c895d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4835d6c446573bedd5fa85dd1abbd5eb50fef65610c6cd7383b576a3fd28648c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8216062df81ccb90fe9359e6ac6f08e12c02e6f38b9ddb3b1172651623fac64e"
    sha256 cellar: :any_skip_relocation, ventura:        "d5474e2a11e89639c15d33d74bf07cef703cbab19066253726db2c279927b047"
    sha256 cellar: :any_skip_relocation, monterey:       "9b8838abd29b41dbcdc88e7965790fff5359511a55212e10eb9406123e264838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a833ff3eade905b385e8f5029aee4c95faa64390f88f62bab6172f92332aa9"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "espflash")
  end

  test do
    stable.stage testpath
    output = shell_output("#{bin}/espflash flash espflash/tests/resources/esp32_hal_blinky --port COMX 2>&1", 1)
    assert_match "espflash::connection_failed", output

    assert_match version.to_s, shell_output("#{bin}/espflash --version")
    assert_match "A command-line tool for flashing Espressif devices", shell_output("#{bin}/espflash --help")
  end
end
