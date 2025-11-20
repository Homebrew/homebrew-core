class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "6591daeb4a633799faff0fd1233e0723d7482372faea871cae46b4c6b0139b41"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0773290548d100ce65b60faaefa6179628c995935a1f32aaf60bee00b76ebed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc2edd56b32c499af537067b90b49db07f24bc14133cd8fde6ddf3a75b64561"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a936dfc5046337540970ab652511b328119e911360cd775551e53e426905e82"
    sha256 cellar: :any_skip_relocation, sonoma:        "d91360749c92af335f5b24364bde4584e10d32f72679f305675b0f37f25f929c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d6ad56860d7dcda4df9b2e37cd7953ba598777936001ce2491c6b72a518fdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4eff95e1a51771e5c46987fa49b73342d0edb21122c924fa4f84da031a3b82"
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
