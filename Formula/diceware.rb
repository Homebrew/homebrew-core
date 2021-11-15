class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/d7/af/85373be6b11706fa1392e52d7fcd47df47f661e238251c931d469e62c5bf/diceware-0.9.6.tar.gz"
  sha256 "7ef924ca05ece8eaa5e2746246ab94600b831f1428c70d231790fee5b5078b4e"
  license "GPL-3.0"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2132a0edadb2a5374057d739624a028b10e3dbb11a3db965ef58c4bd24c02d30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2132a0edadb2a5374057d739624a028b10e3dbb11a3db965ef58c4bd24c02d30"
    sha256 cellar: :any_skip_relocation, monterey:       "7d3214626147512e9733a5a3e5acafcacf5b2b3321dadf72b932d8c42272f8da"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d3214626147512e9733a5a3e5acafcacf5b2b3321dadf72b932d8c42272f8da"
    sha256 cellar: :any_skip_relocation, catalina:       "7d3214626147512e9733a5a3e5acafcacf5b2b3321dadf72b932d8c42272f8da"
    sha256 cellar: :any_skip_relocation, mojave:         "7d3214626147512e9733a5a3e5acafcacf5b2b3321dadf72b932d8c42272f8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b3b8ff4b88ba02d381e3e1b78823980a742174f4a46b85164c70a18b123099"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
