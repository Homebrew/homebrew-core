class LsusbLaniksj < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://github.com/LanikSJ/lsusb"
  url "https://github.com/LanikSJ/lsusb/archive/refs/tags/1.1.6.tar.gz"
  sha256 "deaec63e7bc7185982669473cb5aca245adcfd79e9b0b3a22da3c67d13a9b40c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91567565c865110b0eb54d3764147d207b813c456c2b3cfc8fe857e35ffa5259"
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
