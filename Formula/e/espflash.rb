class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "62cc57be0e97e0370a6c05de82241b2f3e68c51969d6bca0446bd70c244c055f"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "112540b70f0d0624b112fb01764d135e58f3ae1d8801a8a26ca5e0d1000d7427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b21fee967f14e5b4834e2115bdbead2d3f96852ab05f055b97828b8f2bdd9ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a32ad9e30171b22dfc08f3e9fa23e6ffb7980d0a8f9325b4e5b294b38c91fb47"
    sha256 cellar: :any_skip_relocation, sonoma:        "c238983a6a9a9394b676ff8a229e41546e07006c9f91411b3859359fc55d6f24"
    sha256 cellar: :any_skip_relocation, ventura:       "e17b49c69ee6f1e38527ce406c4b70cd4aeb72b57c8fa3f4f108dbc7c0b96a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5970508dd04c6c75d2251249e482d1117a2699174eb606e788d12903f2ac81ab"
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
