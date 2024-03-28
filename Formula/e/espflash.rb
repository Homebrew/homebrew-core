class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "ec24f052345f2ffba0e820ac7b389395f6e54f38545eddc62758079f2b9c7697"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "badf6e480c566b32235fa30b15121ba5652c32a02704a93e78e735d017ca6515"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f518c42e2581dd1f2e069e9e48ca1fab99fb6e8460f4f594e75ff130dcbc8386"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7faff97b1c68c018016788512f29aedef04a607dcd5f005fc1f753c6ee7b621e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba6f3a38f4917bc8009c035d9604eac144361851eb9b0965e525e295e789d66e"
    sha256 cellar: :any_skip_relocation, ventura:        "d287dc886b0a710e1f381356a849157e8b412f80e03cba5362d62ba220066c12"
    sha256 cellar: :any_skip_relocation, monterey:       "52903b0a9509e9fcd3a3d9d9fe27052e590d1e700ce6aac840892a34426e9176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fded9c6104b3c5d670408e102cd5655e3ad2251eb51f488e6acb0031c42a545f"
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
