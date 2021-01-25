class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/1f/82/7c22f218a7fd3177def489febc9b8c262a3b2bcb6785d05e15d435ddcab8/git-remote-codecommit-1.15.1.tar.gz"
  sha256 "cd99d44a94f9adf8c5f15110d830f62af5fe644030fecc0df68cbda4880a5214"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aws/git-remote-codecommit.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "aee7f65ffcaa551a185eb59d6917972265d3c9508c15f52c725e2ceefa6f9c04" => :big_sur
    sha256 "691f3751dfa60d1ead71976570b5b06a76fb6546e0f0cd000e146512c332ce69" => :arm64_big_sur
    sha256 "60e9845d4b0b0cf980e05903b93c19a320a78a530547b1730a3a740c658d2c67" => :catalina
    sha256 "841203b77fc24bc7ed3f426de14421ef19d4062c3eaacf8493c624057b3b0352" => :mojave
  end

  depends_on "python@3.9"

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
