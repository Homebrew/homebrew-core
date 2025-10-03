class Lsusb < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://github.com/jlhonora/lsusb"
  url "https://github.com/jlhonora/lsusb/releases/download/1.0/lsusb-1.0.tar.gz"
  sha256 "68cfa4a820360ecf3bbd2a24a58f287d41f66c62ada99468c36d5bf33f9a3b94"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2bb1064f475b6066dde9e1ad55789b66bbc7335765f22ccd7e5961d20af59508"
  end

  depends_on :macos

  conflicts_with "lsusb-laniksj", "usbutils", because: "both provide an `lsusb` binary"

  def install
    bin.install "lsusb"
    man8.install "man/lsusb.8"
  end

  test do
    output = shell_output(bin/"lsusb")
    assert_match(/^Bus [0-9]+ Device [0-9]+:/, output)
  end
end
