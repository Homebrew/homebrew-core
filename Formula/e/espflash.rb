class Espflash < Formula
  desc "Serial flasher utility for Espressif SoCs and modules based on esptool.py"
  homepage "https://github.com/esp-rs/espflash"
  url "https://github.com/esp-rs/espflash/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "ea038015c548421c4aba4a3ed7391ab831d7003d09944f1ac247c77dfe090341"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1e30cbba1b4711890fbe1f435352ba3b06da0054710ba519a1f91e33a4cd14e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b303b44d33cac494f540f795cc17fec581827f3b3f835b0d36385469ecbfad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e9eba0a5f7280288a9b6e1a1b666af5220492bec7995ee2c25e7b2148b791a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5e2121b6dd229722b0bca9868113a369e898b09524207dd2fbe17377a7a7bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae3c812a3e2c2a0a2ee029fb71317e8c4f46a242258a2e370dcbd9edfe7f552f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f2c7d557115250dcedb4fb1599883298479d8843b47d49ec8598618f0c11ad"
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
