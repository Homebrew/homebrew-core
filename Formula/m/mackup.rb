class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/b6/68/a5376d04e89d65a4a4665c5d01d8e763a78b25d1443250a98204a9ab6b75/mackup-0.10.0.tar.gz"
  sha256 "1121700a83f7b6cefe6a52bf0c71b870c511b99eeb2a50b2a30c96cab19ca1e0"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27ca8bf95995984a2a83d78c1af745524e36647e27a40ad59734fc5c5db472c3"
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
