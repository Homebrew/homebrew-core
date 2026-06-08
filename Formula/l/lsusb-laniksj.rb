class LsusbLaniksj < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://github.com/LanikSJ/lsusb"
  url "https://github.com/LanikSJ/lsusb/archive/refs/tags/1.1.8.tar.gz"
  sha256 "ba85b34c59ab16bbb50b996a76a48368925b7df6d1e9716240f70ea5f949498e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6d82705815063fd6eb8fe7e4e7639abba930021dc9849ed47ff18b43fddc76d"
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
