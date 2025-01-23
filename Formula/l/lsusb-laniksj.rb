class LsusbLaniksj < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://github.com/LanikSJ/lsusb"
  url "https://github.com/LanikSJ/lsusb/archive/refs/tags/1.1.4.tar.gz"
  sha256 "14eb90962515c4f63aacc56750d0d221e57a5bb7cf12577193de6bc261e70be6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "478e380b7221d17b4ec6d9de9c843f500032e00ec521bfd539805927e1141914"
  end

  depends_on :macos

  conflicts_with "lsusb", "usbutils", because: "both provide an `lsusb` binary"

  def install
    bin.install "lsusb"
    man8.install "man/lsusb.8"
  end

  test do
    output = shell_output("#{bin}/lsusb")
    assert_match(/^Bus [0-9]+ Device [0-9]+:/, output)
  end
end
