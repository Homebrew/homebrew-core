class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/58/d6/dd5e60719e8f75117ea0462f690c0bfffee9483f2438cf0408255900e36c/mackup-0.10.3.tar.gz"
  sha256 "f0166a3b2bd9d01e51d0287d9129a533939919c4eaee3f55fa018aab2bafd3ca"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81ed520ea0c8dfe004b2d2a6c7b077ae8c852489af691bdd1ffcb2d16bc61d20"
  end

  depends_on "python@3.14"

  resource "docopt-ng" do
    url "https://files.pythonhosted.org/packages/e4/50/8d6806cf13138127692ae6ff79ddeb4e25eb3b0bcc3c1bd033e7e04531a9/docopt_ng-0.9.0.tar.gz"
    sha256 "91c6da10b5bb6f2e9e25345829fb8278c78af019f6fc40887ad49b060483b1d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mackup", "--help"
  end
end
