class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/f3/d2/03f4742da635ddf4bd3c13e9857d185b4d6c8c738e344afd80b527400288/codespell-2.2.4.tar.gz"
  sha256 "0b4620473c257d9cde1ff8998b26b2bb209a35c2b7489f5dc3436024298ce83a"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f9c1485c7ab8c1d744e4dc28047c1f6f40bedf1a9cb2a3ab682ec8ff1c1ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f51e3819592396550ca7dc8a3f6d5996cba1ff506cc9bb0c5a548431dda67747"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "717cb11e6266a0eadd80c1bb7714b0f63b82cd495831794fee6327194c09ee2b"
    sha256 cellar: :any_skip_relocation, ventura:        "51359239211f6da5cc1f868704d79d8e80a75239840c99144434c8e1de0ebdee"
    sha256 cellar: :any_skip_relocation, monterey:       "08ea60c93946a042a5a3f45b990634ea91ab38019a7cfa44802ee458c1cf4e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3b4d5bcc19047c990b5fbfac7b07f2e6c4f4397a33bb763898526664e7d0f3e"
    sha256 cellar: :any_skip_relocation, catalina:       "4f385712a7b4d05b553731e2040f940f30202c668dc8acac85def37bc10226a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14e7c7923c08ed1145ee63380e859b40046bee3432d6e01f823725efef72670d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
