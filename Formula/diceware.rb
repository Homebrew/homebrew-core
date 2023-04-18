class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b3dea6379d779fcb283ba0bd71a8955ca4e3dd1ba3a3b007ff88543d0a76d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b3dea6379d779fcb283ba0bd71a8955ca4e3dd1ba3a3b007ff88543d0a76d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b3dea6379d779fcb283ba0bd71a8955ca4e3dd1ba3a3b007ff88543d0a76d3c"
    sha256 cellar: :any_skip_relocation, ventura:        "72b062456e3ff046ed6cb143ed36aa89d762f245d6f8a4278fc404a14d2d5979"
    sha256 cellar: :any_skip_relocation, monterey:       "72b062456e3ff046ed6cb143ed36aa89d762f245d6f8a4278fc404a14d2d5979"
    sha256 cellar: :any_skip_relocation, big_sur:        "72b062456e3ff046ed6cb143ed36aa89d762f245d6f8a4278fc404a14d2d5979"
    sha256 cellar: :any_skip_relocation, catalina:       "72b062456e3ff046ed6cb143ed36aa89d762f245d6f8a4278fc404a14d2d5979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf96f6848831e2b09a09cea6559df72f621314df4c567b3313dc6404fdb04845"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    man1.install "diceware.1"
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
