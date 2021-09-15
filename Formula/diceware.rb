class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/d7/af/85373be6b11706fa1392e52d7fcd47df47f661e238251c931d469e62c5bf/diceware-0.9.6.tar.gz"
  sha256 "7ef924ca05ece8eaa5e2746246ab94600b831f1428c70d231790fee5b5078b4e"
  license "GPL-3.0"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca1614ff22e5504fe1e2ebcdc11ba9e91043e33fe7d43b0d4cba802523604dfe"
    sha256 cellar: :any_skip_relocation, big_sur:       "79f18254a3631e1cd5e3f1454ba1e8bdb543d40bf3ac32ae7e16a140e1a05691"
    sha256 cellar: :any_skip_relocation, catalina:      "fd0844df14a177f46686016e0c0c1a3b741da092efc17ee312c1a808c3026ae6"
    sha256 cellar: :any_skip_relocation, mojave:        "cedb8a95fb39b3de33096f5c42b67c7aa92a79441d09d0477ecaaaeec007fc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fb5a144eb5ddefeda40f9426a52b23e789822fbf35168c059d978425143e892"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
