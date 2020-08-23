class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://github.com/aws/git-remote-codecommit/archive/1.15.1.tar.gz"
  sha256 "23bcc0715c72217f8dcd5841aecce537c360138016baa6b1ed9a2873af546e0b"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "71392ab342c2b182d371f8219cd176705b2d98d790868c146c058e0642108bf6" => :catalina
    sha256 "563bc42f34b6b865a790d8b4b7bf17db9693b09d31ae650c441882f67569fa85" => :mojave
    sha256 "f8e50499e041294d303aaf3c4b2fc72de65d6e4a1fb13bd267287045f721ee92" => :high_sierra
  end

  depends_on "python@3.8"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/a7/10/d9bbdbee6d3ea63897e468dddabb3edb7b7360a901e3eee249cdb132a78a/botocore-1.17.43.tar.gz"
    sha256 "3fb144d2b5d705127f394f7483737ece6fa79577ca7c493e4f42047ac8636200"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
