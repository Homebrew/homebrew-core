class Flash < Formula
  desc "Command-line script to flash SD card images of any kind"
  homepage "https://github.com/hypriot/flash"
  url "https://github.com/hypriot/flash/releases/download/2.7.0/flash"
  sha256 "94dab725e4839ac7ef9254ce7f9bd96791089d6aa98495e23826845ed256427f"

  bottle :unneeded

  def install
    bin.install "flash"
  end

  test do
    system "hdiutil", "create", "-size", "128k", "test.dmg"
    output = shell_output("echo foo | #{bin}/flash --device /dev/disk42 test.dmg", 1)
    assert_match "Please answer yes or no.", output
  end
end
