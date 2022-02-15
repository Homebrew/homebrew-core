class Diceware < Formula
  include Language::Python::Virtualenv

  desc "Passphrases to remember"
  homepage "https://github.com/ulif/diceware"
  url "https://files.pythonhosted.org/packages/2f/7b/2ebe60ee2360170d93f1c3f1e4429353c8445992fc2bc501e98013697c71/diceware-0.10.tar.gz"
  sha256 "b2b4cc9b59f568d2ef51bfdf9f7e1af941d25fb8f5c25f170191dbbabce96569"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba158bc1e6f66da51dbf0817e67ccb99ab828b283a93c239b805edd1731a76de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba158bc1e6f66da51dbf0817e67ccb99ab828b283a93c239b805edd1731a76de"
    sha256 cellar: :any_skip_relocation, monterey:       "33faf48fdcd74c69c466794bd6559bfc5b6b4d6f18a6e56e81a2ee3d1fb302b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "33faf48fdcd74c69c466794bd6559bfc5b6b4d6f18a6e56e81a2ee3d1fb302b8"
    sha256 cellar: :any_skip_relocation, catalina:       "33faf48fdcd74c69c466794bd6559bfc5b6b4d6f18a6e56e81a2ee3d1fb302b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ffea931d997e34db9d26035858da3842502eca81ab5f895646f378829dc7318"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/(\w+)(-(\w+)){5}/, shell_output("#{bin}/diceware -d-"))
  end
end
