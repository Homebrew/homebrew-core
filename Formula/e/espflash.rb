class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "f4eb66af5ca11a396b238878d339ca38d9ddcb7c619b47ed5fc91b7f7b4e54ac"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81074a30fcabaaec83c0f923c21b3741af0e8bae338d41bfa57cab0ec2539870"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e7376eb6973a25c45dcad18f09d4c3f06612be127f363f0553852894140271d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e1e5de9cb685b68e69c15d3fe1addea4448e62dfc1c98d80977abda4584dfc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6a8e8e2a2fa5e5ebe008724bfa66a24c998750dd079c2907cc79d47419f16c6"
    sha256 cellar: :any_skip_relocation, ventura:       "c2a7abbc65110221d8fdd9f1ed17774909462ce9857c250cfab04b886ccef7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1159d6a52f878074685cb190134179cbf6b10846482d103dd0103f046e003d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3dd1267b7fd248b893dee7a09dd65caf7981ce5752009521bb6822751581bbb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "espflash")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/espflash --version")

    output = shell_output("#{bin}/espflash flash espflash/tests/resources/esp32_hal_blinky --port COMX 2>&1", 1)
    assert_match "Error while connecting to device", output
  end
end
