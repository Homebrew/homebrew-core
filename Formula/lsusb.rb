class Lsusb < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://github.com/jlhonora/lsusb"
  url "https://github.com/jlhonora/lsusb/releases/download/1.0/lsusb-1.0.tar.gz"
  sha256 "68cfa4a820360ecf3bbd2a24a58f287d41f66c62ada99468c36d5bf33f9a3b94"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ab2cb027f186840ea1c96e47b4d48a8dfc42d91847d79bdd3faa6677ef603ca" => :catalina
    sha256 "4f2f4f45cb6df2d5262bb823e02f750e7e5b4f117dca8a41fc6956435a277cb9" => :mojave
    sha256 "e696db36d09169064b3e97852d07464125e5bc6e400cb2a4cc186e6aa606574a" => :high_sierra
    sha256 "e696db36d09169064b3e97852d07464125e5bc6e400cb2a4cc186e6aa606574a" => :sierra
    sha256 "e696db36d09169064b3e97852d07464125e5bc6e400cb2a4cc186e6aa606574a" => :el_capitan
  end

  def install
    bin.install "lsusb"
    man8.install "man/lsusb.8"
  end

  test do
    output = shell_output("#{bin}/lsusb")
    assert_match /^Bus [0-9]+ Device [0-9]+:/, output
  end
end
