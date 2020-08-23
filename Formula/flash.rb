class Flash < Formula
  desc "Command-line script to flash SD card images of any kind"
  homepage "https://github.com/hypriot/flash"
  url "https://github.com/hypriot/flash/releases/download/2.7.1/flash"
  sha256 "879057fea97c791a812e5c990d4ea07effd02406d3a267a9b24285c31ea6db3f"
  license "MIT"

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
