class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "78ca6413759329b850221486a2cbb8372f2907d39b4ae6a1bbab2aa5ef3f57cd"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5793089447bbb902b8c3872644e7cf40c52a431ec1acf03e4a66613035c252c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00e2fca0b083129253bb2253a4fd6db0a8181c7e47a0ca3971574baec299c0b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "635163aa7632c665b5e91a0d307abe9dde6ac7fa3c628c06101cb6cc062ef5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c74bd16a6cbcf547ccd22e0cdbcb3fb79136f031a08bd9fca600b8742755218"
    sha256 cellar: :any,                 arm64_linux:   "2b9bcf9a1d007ca78252a889546a9cbe4e5703c7d05d17919acc567769da48f6"
    sha256 cellar: :any,                 x86_64_linux:  "e95019da4fa65b2e41c6f9b4f71a3c6e0f56892d34c2bc104d237a0b230a573e"
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
