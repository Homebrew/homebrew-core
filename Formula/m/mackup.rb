class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/b3/57/21289b0d607e0bef6942bb8debe62c83e93855d6e7bb64148f53205bac87/mackup-0.11.3.tar.gz"
  sha256 "efb0d6e33abb4437cb3d382ae4255348ea7e5ea437a33d40ec03869b54bde381"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df41d70b2de6ee88cbf92eb532a0874e81851117be4a1cd77ee5315eb251b6dc"
  end

  depends_on "python@3.15"

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
