class Lsusb < Formula
  desc "List USB devices, just like the Linux lsusb command"
  homepage "https://github.com/jlhonora/lsusb"
  url "https://github.com/jlhonora/lsusb/releases/download/1.0/lsusb-1.0.tar.gz"
  sha256 "68cfa4a820360ecf3bbd2a24a58f287d41f66c62ada99468c36d5bf33f9a3b94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ad2f30f538b1ec0122a492b6e5f07ee70b2d7f2bb9e1cd267b8879b7534dc7d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1b7ef763a83e68074528407469fae8fd265269981332d139ab0acca67ea4376"
    sha256 cellar: :any_skip_relocation, catalina:      "7ab2cb027f186840ea1c96e47b4d48a8dfc42d91847d79bdd3faa6677ef603ca"
    sha256 cellar: :any_skip_relocation, mojave:        "4f2f4f45cb6df2d5262bb823e02f750e7e5b4f117dca8a41fc6956435a277cb9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "e696db36d09169064b3e97852d07464125e5bc6e400cb2a4cc186e6aa606574a"
    sha256 cellar: :any_skip_relocation, sierra:        "e696db36d09169064b3e97852d07464125e5bc6e400cb2a4cc186e6aa606574a"
    sha256 cellar: :any_skip_relocation, el_capitan:    "e696db36d09169064b3e97852d07464125e5bc6e400cb2a4cc186e6aa606574a"
    sha256 cellar: :any_skip_relocation, all:           "cb58c67458e54e712ac52a4e6ffcaab384ad2e7b61bad32c21daae3f16a42d5a"
  end

  depends_on :macos

  def install
    bin.install "lsusb"
    man8.install "man/lsusb.8"
  end

  test do
    output = shell_output("#{bin}/lsusb")
    assert_match(/^Bus [0-9]+ Device [0-9]+:/, output)
  end
end
