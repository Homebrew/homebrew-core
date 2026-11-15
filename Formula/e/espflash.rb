class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "c8ded03faad091d502b9c4d755e4b04636a7a9ee721baa6bf1492075fc8224c4"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4527ea31980a49e3dc6bb7ada57450bd49ac4892421e989a5c8eb265c9584ab8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0544da064806152aa6786c550cb4011c0396f574b3c95ed00d3044cbaaaf3ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c83b49d2e8b761d2456455cf7b9814777dcb5801603af4c2b52ff337eb0f10ea"
    sha256 cellar: :any,                 arm64_linux:       "ecfd70c42a65b769501b84cd849ffd04c011d50e322efd81a6bb036e71d712f1"
    sha256 cellar: :any,                 x86_64_linux:      "d81e66fe918a2d697d5c8ccb4ca3285b3db72c0c080cf10f3f5dccb845694c73"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "systemd" # for libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
