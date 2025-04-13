class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "5f641653d2112904a02d4c67e1fba6564a7fc23fbb34def2df8ce6ac953a4163"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c81a6ed6df9c49a708d7e87ab635a7e786abc835d74b2eb0fa4686122b31e7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c99e0a9083f12ce47ef06a45bc895deebf5ebdc3b2e5d993dce45109f997934"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cae222d3a510e1fd99493fc84bc30a7a883913d214dde264c5597f50e0c75d3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6504173907b67fc7247bfda8c0bace89f37a1852d540cfd264cab8c391a08ce"
    sha256 cellar: :any_skip_relocation, ventura:       "558ac26ed5f9655a64e6eeecd8a207aa14c0a2cccdb31b341be1a6d5e33eee80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "042f5da2c9430440c0b144341933160ee4e4d322b6a154051edc3619a5337025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50eff44ba9819e9af58b258224a56270d72773c2f445b070ec1b1ecd69310092"
  end

  depends_on "rust" => :build

  on_macos do
    depends_on "libuv" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
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
