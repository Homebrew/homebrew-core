class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://files.pythonhosted.org/packages/c9/80/3c0f1755c612f32a215b2ebc8a2669a9b7f78d2ada58bbf1002d94601c79/mackup-0.8.43.tar.gz"
  sha256 "22bb21412dfee660a5ec2ef018b95302eb72635cf45b04cbc7f53364de24ed54"
  license "GPL-3.0-or-later"
  head "https://github.com/lra/mackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f0d80fa9efb59208a386293d95384f3440291ba11121fc43dd4c69707b515fce"
  end

  depends_on "python@3.13"

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
