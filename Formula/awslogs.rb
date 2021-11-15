class Awslogs < Formula
  include Language::Python::Virtualenv

  desc "Simple command-line tool to read AWS CloudWatch logs"
  homepage "https://github.com/jorgebastida/awslogs"
  url "https://files.pythonhosted.org/packages/96/7b/20bff9839d6679e25d989f94ca4320466ec94f3441972aadaafbad50560f/awslogs-0.14.0.tar.gz"
  sha256 "1b249f87fa2adfae39b9867f3066ac00b9baf401f4783583ab28fcdea338f77e"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/jorgebastida/awslogs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32c55578a0be83b8b1360d273c2582e1212cf34366fb9eb89a418c79d477f4b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b9382f684ca785d44994e42278975e7bac5d4c64cbdae7aea207593195cddfb"
    sha256 cellar: :any_skip_relocation, monterey:       "bfec50979aeca7c3b556550dd34340864776a7dd9f55f3cbb3470a17d0944c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a0c2dce4e6ad80585449b305981e6361bfa71ba99535951e0869a838dd3b50"
    sha256 cellar: :any_skip_relocation, catalina:       "9a26d97dc7b768ddbc3d11b08995d45972019b10b089117c98ff75e746ec161b"
    sha256 cellar: :any_skip_relocation, mojave:         "cef5658727d8238b1539f15fe8c34483d1a7deb0d195b2a8eb4bcd540482f145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9dfd6486ab00fb984d9aa25f1bdbcfb5e44b286960ad8e294847370d6a2f768"
  end

  depends_on "python@3.10"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/bc/9c/960e500e3108dc43966cbf56861575786d068089c17c581f6efbfa228aab/boto3-1.14.20.tar.gz"
    sha256 "e6ab26155b2f83798218106580ab2b3cd47691e25aba912e0351502eda8d86e0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/98/89/388651fcd98d8b9be63c44e356e28c24f742259cea507c13f501e623a4fc/botocore-1.17.20.tar.gz"
    sha256 "d1bf8c2085719221683edf54913c6155c68705f26ab4a72c45e4de5176a8cf7b"
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

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
