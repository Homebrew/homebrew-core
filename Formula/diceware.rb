class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

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
