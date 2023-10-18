class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/96/7b/20bff9839d6679e25d989f94ca4320466ec94f3441972aadaafbad50560f/awslogs-0.14.0.tar.gz"
  sha256 "1b249f87fa2adfae39b9867f3066ac00b9baf401f4783583ab28fcdea338f77e"
  license "BSD-3-Clause"
  revision 6
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca809cd4df271013f3fc169597973c36a2da8aaad1acd013a0030aab9d5a5868"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c9ec5106527c47e249a8173243e6f551edc449bcd6bb1f29c5d06e9a0b39e35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c35238fd41e03a2adb0a739c86ec556bcd16028ac71c8e89c6dc1823efb0544e"
    sha256 cellar: :any_skip_relocation, sonoma:         "373433c6c3d27903d791c8ef5b32ba533047bba9e048ac7f77d6cca9407cb7d6"
    sha256 cellar: :any_skip_relocation, ventura:        "e0b25a41734af4ea468933040f13ee3fc605c5f95f52ca9fbc981e6e8a5b53dc"
    sha256 cellar: :any_skip_relocation, monterey:       "f223d7f6fb309960d54dcc5f701125dc94103b256f9d17a73bdca6d8ff875117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ebd0d7259d98e9f120fd2f4d1b0377b4c9e2a1bcd97e40cc24c0fd06795faf0"
  end

  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "zlib"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/2f/4ccd05e765a9aa3222125da37ceced40b4133094069c4d011ca7ae37681f/boto3-1.28.65.tar.gz"
    sha256 "9d52a1605657aeb5b19b09cfc01d9a92f88a616a5daf5479a59656d6341ea6b3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    inreplace "setup.py", ">=3.5.*", ">=3.5"

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
