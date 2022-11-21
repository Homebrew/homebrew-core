class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/42/57/2b07dc5eb131d34a820bbc08a4437ca2ddfff7a47476bffd1822437de910/codespell-2.2.2.tar.gz"
  sha256 "c4d00c02b5a2a55661f00d5b4b3b5a710fa803ced9a9d7e45438268b099c319c"
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
