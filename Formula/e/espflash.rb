class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "51e1a31e63d11f3f3dbb544d93c03399ea9dc1c5c35e09e502dc542e5b9270f5"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "755583d45a918fe47522af55a973606d8a681257ee02d8574cead6c904c9d4c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aacb2290003780e0c3204b2b581c81cd688f76caea906949433645540ea5bd5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef900e72da730354a8738546cdded8a2e006597a0268f0f91408e9019e57fee0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec0350d93e1f5d2e29863592ca2cc11972f8bf26ff0ae01b1f2ca22ad33d3d2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "584b7fbd88e6151c46ca0fd06e7c035da5d1627f55727093553a42c0791ecccf"
    sha256 cellar: :any_skip_relocation, ventura:        "416d8b7bb1e4cd7d4989de65a93efb3b0366ea50168f566986302e08c828d50a"
    sha256 cellar: :any_skip_relocation, monterey:       "c5167e8ea42ea5d4ff281a15ba7df0ee77daea10ed07a8fe3e5c1e30edcb3544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "412dd4c072eec3441b7f4e66a5f745e567cedac7046a2624000751a02b66f122"
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
