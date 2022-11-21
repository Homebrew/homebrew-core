class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce36271670d7139a0243ebb0cb1620f00928d2e6f182d7864e0486d7671257de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "395c757d0b9b509bdc8cac6fab7ca62f41776ac8c4f19084497f4557ea43d074"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa407323855586ff662152633a7cf3f0709d27749a2263659a3bab5346d35c11"
    sha256 cellar: :any_skip_relocation, ventura:        "2ed0e7d17d18a5ba02d48abbefba2b98d6a1136318ce577c9686b70ccf0f9591"
    sha256 cellar: :any_skip_relocation, monterey:       "ba9858ab186028927761105bc34c97a2327fd2847d3406d3b4034b0ab8798632"
    sha256 cellar: :any_skip_relocation, big_sur:        "85234449152d46566447668a7cb38ec9e656dcc4abcbc6d54f4881ddaeaeda5f"
    sha256 cellar: :any_skip_relocation, catalina:       "ef2d0fd58f0d50a4b9aafc5702942bd59f77bbb6c1b5fd5c5afcc823d076736d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41987f5f58c200ac868b2dc992300ede78e3634bf456b42b1bde1ab8b922354a"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/aa/3e/e4edeef9621068e27ce1d4cd10b847f00ef7de1c337ee70fb2ed67b32449/awscli-1.27.4.tar.gz"
    sha256 "e43ecfaa173d7af6d557f746b41827b831908b3c5db3572b352df0c0ab514dc3"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/df/e4/893fc4af6ee0c801725b48ba4d3120705126edab71e0fe84f8eb4850c427/boto3-1.26.4.tar.gz"
    sha256 "244fd0776fc1f69c3ed34f359db7a90a6108372486abc999ce8515a79bbfc86e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/32/c1/3a3cbbdc58a71c1dfafbeeb79dd09b68a030ff5c52df7ad8e87d5ed57c10/botocore-1.29.4.tar.gz"
    sha256 "fa86747f5092723c0dc7f201a48cdfac3ad8d03dd6cb7abc189abc708be43269"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/64/c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4c/prompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    # setuptools>=60 prefers its own bundled distutils, which is incompatabile with docutils~=0.15
    # Force the previous behavior of using distutils from the stdlib
    # Remove when fixed upstream: https://github.com/aws/aws-cli/pull/6011
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      virtualenv_install_with_resources
    end
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end
