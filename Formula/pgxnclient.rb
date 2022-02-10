class Pgxnclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for the PostgreSQL Extension Network"
  homepage "https://pgxn.github.io/pgxnclient/"
  url "https://github.com/pgxn/pgxnclient/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "0d02a91364346811ce4dbbfc2f543356dac559e4222a3131018c6570d32e592a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de5cf5435853c4bc97a8f8e03b22bb0f1d6a6ca39d236b704c008300674babbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f1cc258ccef1af3e299dfcd09e57c7ab20728a1a566b13a1eefc422358333b8"
    sha256 cellar: :any_skip_relocation, monterey:       "71d9a954b9e1f4a103289309c761993de612a309a9d7ee321727f565f5d1e6ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "56239b4009c755adad5f4fe5b80261f7b3ed7b8cd2e2b84f81a99afb822b89ff"
    sha256 cellar: :any_skip_relocation, catalina:       "5750733bf95b281d29cb50803df509f14c7ec0f514a042541e45874560ced570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a3082f3981aef9a53a92fad8b10ffd0634185881d148827823ae0524850a824"
  end

  depends_on "python@3.10"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pgxn", shell_output("#{bin}/pgxnclient mirror")
  end
end
