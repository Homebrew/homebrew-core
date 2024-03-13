class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ec24f052345f2ffba0e820ac7b389395f6e54f38545eddc62758079f2b9c7697"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4866a3d27c2a2b7c01358bc5aafbf7a01d79dd5335b897ffa1e68a8d89f969c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9825e9f2533cc09518f44689cbabd5fb0a607bcd586054ef6aa5ba2b226fa3db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "976109b475ee90f0cfaebffa94f5b2b0f4433ab141ecddd4de1d24bc3428fada"
    sha256 cellar: :any_skip_relocation, sonoma:         "a60c76c7d2d096f9f1984c8378d7a2d0f2573eb0b459fbec8e3ae233f7c4aa2d"
    sha256 cellar: :any_skip_relocation, ventura:        "1694bb6181d17267e225b5b671806d5eaa92f528dd29a937347e5fe495aab3fb"
    sha256 cellar: :any_skip_relocation, monterey:       "25be9d3266502248ed3a7a2f1d57bfd2b777a88cea5032621e8096fb5e4e45f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dddd24c74da2eacbce4c0c263836c9327fb958e41795b82046a4206db7bbb30"
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
