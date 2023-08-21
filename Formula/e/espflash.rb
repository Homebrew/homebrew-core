class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "be6067c1404d00ff1fc9e1838b313902cb1de4ecfc8efab0e67a678a04c7c9b6"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b476cb351d4bc0552fd9e2cea5a37a0820f0849f37bf95004c9789045db5258d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ce4fa2ab7989f25c01c40769353829ae7c8016e7aa2cd5d090efb911501957"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caef07e7fd0689fb2c1d4438a2823a8b028fb3253e688ebc82f5404356d138ed"
    sha256 cellar: :any_skip_relocation, ventura:        "dc3fe54e282e33c4f9d1c58bdb16e70ac3c04c9b9015933583cd9013c8e83f18"
    sha256 cellar: :any_skip_relocation, monterey:       "8219fa9476ea1d47d811631c603e33b83e0ad4d64dc2ca0307def5ab22bccb5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "53490d057f2943e015025cfedca140b2d5b803cc084737f1ccc64ec93008a3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b5713698ca478584789341b429edf5e6c0a023e49277f5314a3f092f58a9da"
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
