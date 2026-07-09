class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "2748bb1d3952e63fba67e3e07cc6496ac2a8658ab3b27ad5d47168a8150ef3d4"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ce6d471a3ac8576d0a23338601cdb4e7a04ca970456f7c15054fcc3f6eb32ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64d9779c15d95f959261cf45237af189180656d86535bd97e9f8bb1f17c07801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f0e4d819490ce64519baf03e97024ffbaa89be6e0b33378a9349947f2774ae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f86958210e14a20f67adfebf0f9eb2194a16f025cab683edeca5afe1fa7fc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d9209050191bed2bd021b91d7f1eebfeca647635e6c457ee3d32bd5e5e85308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae73809637c9666fef1d5ee9b594e58f6049a4257ca2a2c0f3a5eed6bd7d49b2"
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
