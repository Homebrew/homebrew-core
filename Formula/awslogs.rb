class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/96/7b/20bff9839d6679e25d989f94ca4320466ec94f3441972aadaafbad50560f/awslogs-0.14.0.tar.gz"
  sha256 "1b249f87fa2adfae39b9867f3066ac00b9baf401f4783583ab28fcdea338f77e"
  license "BSD-3-Clause"
  revision 4
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e6c01c7db955f53c3dcc18b3a24fac169f5a3778a7c5df6c302edb9ef024c81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29129ede0efa5097cf53f57f0affafa5f2ec960b1fa81c5fd896aa7e3278af05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "311a561ec79b832015fbef9b52c15533c3bbe006104cdd999d43f70b9860bd2d"
    sha256 cellar: :any_skip_relocation, ventura:        "9317592b5b6dad41d08b859a03fa952bb2fcc12300436c2c774badf65b775659"
    sha256 cellar: :any_skip_relocation, monterey:       "633cbe72406fbb4afa1920f8bdd082e662300e7d5293afc2dcd776b09fe2f96b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec87edb19c90a6235b5d61d57266c032c7db15dc5bc28edabf4d870f8df23e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16a5665bea7425a24e1a8c73a99e5e6268c5394498da4f18d2cbe8cf0297f809"
  end

  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/2d/ae/7a28ce6d8eb6b4e5ae1c7cf302179a6ef78c11f7a54e818df5dd7b237724/boto3-1.26.73.tar.gz"
    sha256 "bd92def38355ea055c6c29bd599832878eecc19cad21dab34ade38280e1b403b"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e8/0a/bc0b30cc6c97072c350276d7b99b16100d1c6743942e8880af237344d914/botocore-1.29.73.tar.gz"
    sha256 "a9f0e006b3342424d59d5e23dc1ca0c6972c909a727dcd0811c9b20966d4adf8"
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
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/e5/4e/b2a54a21092ad2d5d70b0140e4080811bee06a39cc8481651579fe865c89/termcolor-2.2.0.tar.gz"
    sha256 "dfc8ac3f350788f23b2947b3e6cfa5a53b630b612e6cd8965a015a776020b99a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
