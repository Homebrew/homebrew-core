class MacBrightnessctl < Formula
  desc "CLI tool for controlling keyboard backlight brightness on Mac"
  homepage "https://github.com/rakalex/mac-brightnessctl"
  url "https://github.com/rakalex/mac-brightnessctl/archive/refs/tags/0.1.tar.gz"
  sha256 "2a275269326ef2a396d87b5b1dff4779d9a003e9474454a6f0df32e01b0bc4d7"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    def install
      system "make"
      bin.install "mac-brightnessctl"
    end
  end
end
