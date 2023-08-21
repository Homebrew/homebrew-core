class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16e19da1bd5a67d1478ac2a40db430245334c7955a0f6b40b4d46805229ee426"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3b82978d9d5dfb276982e23099f73972f5f732423b067c0eaf6885cb3090c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af5e5d0612617d843ea88b11f90f690a902aa629523dbf76fe30ef3b496aa3c"
    sha256 cellar: :any_skip_relocation, ventura:        "2768bc268f361f51fe2140ebe9a935c2f5e9a8130f256eb443a2220cf47471e7"
    sha256 cellar: :any_skip_relocation, monterey:       "9e7fc2c8e331c94dea35c60fd3c92bd3ce6a4c24d0954b17bf918779d4bc11d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e0e989e36f58a7530cf26c9ff52220be7c07f8b49b5f657b8e6c21177e47933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "071cf0a61a8b24cc69de6258ba67d449aba46a9e62e9d200b5621032e000d628"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/35/25/47bbbc251b85a765f5370409369991028719f380345f389304fc0e137cc3/awscli-1.27.121.tar.gz"
    sha256 "f2c7c759095167874b9084a9a1b921801d57d16baba1357dd208c9533606b899"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b2/ab/1a5086e1b32ed9a59ad0e910030200e2b0a6d3ed4aff9cf5f359bf30a5a4/boto3-1.26.121.tar.gz"
    sha256 "f87d694c351eba1dfd19b5bef5892a1047e7adb09c57c2c00049de209a8ab55d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8c/d3/cac011be3a89b877d6c9cbf1ed4c36da0cc948877132fc0ec7a343b6a4dc/botocore-1.29.121.tar.gz"
    sha256 "955c1dd244b6286d9e17dc525d1459a2a74a1c4e519f35006c72f184fbce0760"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
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
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
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
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    # setuptools>=60 prefers its own bundled distutils, which is incompatible with docutils~=0.15
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
