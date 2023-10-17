class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a12cba5c644d071506b0a9d2492ef86373849eee8a879e5addbee22375aa9a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04b3c89ce5cc76e269dd66f295a67df2cea93a61591c38deb3114d88d485907a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c991ce848099168f7219a0e774e6edb9b33204b2abacba6a15ae28e540147963"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e09636931274211cb2cdfa74fcc444eb44d69a62f6b45cc1e9886274c2812cf"
    sha256 cellar: :any_skip_relocation, ventura:        "cbf496d7d686295670443ffe57ba2b35e3d08b3c4193a7841c65bb6cec7080d7"
    sha256 cellar: :any_skip_relocation, monterey:       "5553566579c61d5628590d5ded8c3b23d25e54457e235e99e61fe512820263f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19524978add61efee2c3fe6206201041bf0acf729b370adfe3a87e49e637f8d8"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/5b/6d/bea374bdbd5ed9f570fdd9fa7d44193c7f6d1d4acba72651ec23191736b9/awscli-1.29.64.tar.gz"
    sha256 "6ab3ae53f2354fa43e9c059406782c9399929dae8683eef843f9c7ef1efc2a98"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/67/c6/0baa9f7193b6defe6238b5b1b512be434cb54bdb32f949b8d8823e860e2c/boto3-1.28.64.tar.gz"
    sha256 "a5cf93b202568e9d378afdc84be55a6dedf11d30156289fe829e23e6d7dccabb"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/01/98/3635fd827cd7f758d2010e7bb432853c37b14d58b7bc728d0797d0199480/botocore-1.31.64.tar.gz"
    sha256 "d8eb4b724ac437343359b318d73de0cfae0fecb24095827e56135b0ad6b44caf"
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
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/cb/ee/20850e9f388d8b52b481726d41234f67bc89a85eeade6e2d6e2965be04ba/wcwidth-0.2.8.tar.gz"
    sha256 "8705c569999ffbb4f6a87c6d1b80f324bd6db952f5eb0b95bc07517f4c1813d4"
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
