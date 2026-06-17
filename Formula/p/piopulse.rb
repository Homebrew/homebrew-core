class Piopulse < Formula
  desc "ESP32 factory flashing TUI tool for production lines"
  homepage "https://github.com/Wang-Yang-source/piopulse"
  url "https://github.com/Wang-Yang-source/piopulse/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "ad7cfe0a7a8568abf68a49cf294b1074bf1305f900dbd55adc8d1bcf230981a3"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "PioPulse", shell_output("#{bin}/piopulse --help")
  end
end
