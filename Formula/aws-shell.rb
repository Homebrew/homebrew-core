class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3653675cc0122373ade70de59ba0df5a184248bbe8aa4397b4e3a7c6912691ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45382f49fe45fde97fafbbd7742fb87d8e0551a59559d4f93558c3f7e9faff49"
    sha256 cellar: :any_skip_relocation, monterey:       "f5de04223938146d8d83170b83adafa4135b9d0bf99bc1a3b661cdf69c3ba893"
    sha256 cellar: :any_skip_relocation, big_sur:        "10a2ca9388c9c1dab3f9e591e2ac86139cbd9e50b4becce0ba2f28d23cc51b8a"
    sha256 cellar: :any_skip_relocation, catalina:       "1197cb3c8f0a0450cc1759075a123c5e4c4fab3b22aef31de1e1c386cbba1d1b"
    sha256 cellar: :any_skip_relocation, mojave:         "05da4e2dd7b13c80aa43dcc6d722be02599f6e22a2b0937282cdd9134240188d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1529cff62e2a726e1bfacd3713a5728679f9e56e9c2fe1765b9aee2c1580a7"
  end

  depends_on "python@3.10"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/8d/49/278de10b22bba018b0ab657fcc28862a38543f8abd3e215018db6b742326/awscli-1.18.157.tar.gz"
    sha256 "59bb2bda1f85eafa380d39a06cdc7ecfa0ff37d0b5c2181ebe06cdb14ff58dc1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d0/23/69cc4d4f0534bcce81d9fc84785ead4d9de4b6061219df19f2d157c205de/boto3-1.15.16.tar.gz"
    sha256 "454a8dfb7b367a058c7967ef6b4e2a192c318f10761769fd1003cf7f2f5a7db9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b1/04/657b179b56e12dfe759979e9736d70dcd5c449e4345c629fd2bede0a3235/botocore-1.18.16.tar.gz"
    sha256 "f0616d2c719691b94470307cee8adf89ceb1657b7b6f9aa1bf61f9de5543dbbb"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/64/c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4c/prompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e2/07/25bd93c9c0175adfa5fb1513a20b25e7dd6c9a67c155e19b11b5f3662104/Pygments-2.7.1.tar.gz"
    sha256 "926c3f319eda178d1bd90851e4317e6d8cdb5e292a3386aac9bd75eca29cf9c7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/f7/1a/7837a99fbbe0f48c8e0e15d5418fd8981dbda68286a55b9838e218bd085d/rsa-4.5.tar.gz"
    sha256 "4d409f5a7d78530a4a2062574c7bd80311bc3af29b364e293aa9b03eea77714f"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end
