class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/96/7b/20bff9839d6679e25d989f94ca4320466ec94f3441972aadaafbad50560f/awslogs-0.14.0.tar.gz"
  sha256 "1b249f87fa2adfae39b9867f3066ac00b9baf401f4783583ab28fcdea338f77e"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c457a22e04ef623d43b954bae9a56d0405deceb801279a13260d594d80b8975b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7f9afdefeb804cdd221be20780ffeadfcfdccbd234f549b38d163f9962c6cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "dd66106ec6dd50056c85ce84a7f507890f19338ad95c0d844d333b582923e620"
    sha256 cellar: :any_skip_relocation, big_sur:        "9823d363323b80a5c1c48929a7313b3bef67a0e4c7a891dfca9f80edc526abae"
    sha256 cellar: :any_skip_relocation, catalina:       "96c56ae773c9f68c3b5a0080549b13eafb699ab110198bad5334a8941b294209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a14896857ef941ec8b99d1eae133515be05a45c95eed41ffb809583f0d146cc"
  end

  depends_on "python@3.10"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/5e/ac/e930417b8b389423899cd350643a7814edff04d548accf8bfd686482dbb3/boto3-1.22.5.tar.gz"
    sha256 "dbbeee6d535a311d4d646a9dd683b216bf17d59345367432a22a21b50eb43a8e"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ad/18/0cb0c4f06adc779a13f7e7cbbee3b3ab284c5cada53a3257b4330f6ae880/botocore-1.25.5.tar.gz"
    sha256 "9f2f143fe8581eb9c43c0934b7daf706067afa409171a80b103f458977fcfbd4"
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
    url "https://files.pythonhosted.org/packages/7e/19/f82e4af435a19b28bdbfba63f338ea20a264f4df4beaf8f2ab9bfa34072b/s3transfer-0.5.2.tar.gz"
    sha256 "95c58c194ce657a5f4fb0b9e60a84968c808888aed628cd98ab8771fe1db98ed"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
