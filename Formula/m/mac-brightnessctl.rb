class MacBrightnessctl < Formula
  desc "CLI tool for controlling keyboard backlight brightness on Mac"
  homepage "https://github.com/rakalex/mac-brightnessctl"
  url "https://github.com/rakalex/mac-brightnessctl/archive/refs/tags/0.1.tar.gz"
  sha256 "2a275269326ef2a396d87b5b1dff4779d9a003e9474454a6f0df32e01b0bc4d7"
  license "MIT"

  if OS.mac?
    def install
      system "make"
      bin.install "mac-brightnessctl"
    end

    test do
      assert_match "Usage:", shell_output("#{bin}/mac-brightnessctl --help")
    end
  else
    disable! "This formula is intended for macOS only."
  end
end
