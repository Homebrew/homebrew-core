class LsusbLaniksj < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://laniksj.github.io/lsusb/"
  url "https://github.com/LanikSJ/lsusb/archive/refs/tags/1.1.9.tar.gz"
  sha256 "fb2ea35ff7e3ba06df0f63e65b19034958ad71b74a229eeff7674704ef1ad5bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2bdd1072024a5aa443ecbbf1f614c3ec7175483226c06accb5f007739773992"
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
