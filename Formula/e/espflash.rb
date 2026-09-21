class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "4d6fd3b57e7fc33480df9e4db403352632a3d8af486ed2721a8f5ab3c666195e"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e8425192ff7e3a6210e59ccc49ee1bb0021c9046678d4b82fc35fa763aa675f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19f6cf57497f07dff52a61dbc31aec618ea6e946b70f1bbbafd73f00bc8380eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daec5d703b1ce85de1005bf3e5e700ed2d75c68eb0807ab39ef116c13b02e063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ef2f86c72c70059749bcd396a86910222d7ae2db071d5ae1e8fc51c7c838f4a1"
    sha256 cellar: :any,                 arm64_linux:       "d947eea930a202bb3b5db2ad6673bed2dc00f60d9e48dfe27038b34f46f4bb7e"
    sha256 cellar: :any,                 x86_64_linux:      "c42646ec9fd642369f1fb92d1dc35994de22f9d6502859512d2c7c0736824bcf"
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
