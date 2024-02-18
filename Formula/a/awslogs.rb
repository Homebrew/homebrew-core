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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e021456151564d1ebe59b8d2f3e4a67257e2806784e7d804acbbcc033a5e8a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b6b5f96e8ce0e0194f998531f07e28a2f314419049acc4d35eb448b37a0b45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d7eb7e982ca4c90b3ea9aacdab09a07b215965e326194afb7cd0a156bf090c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ede8888de167ea7a9f6d98587fb5bbc6547548b1dce6da18282289acf1e4689"
    sha256 cellar: :any_skip_relocation, ventura:        "77bf52ea7d2e213cdbd5d5ae6cd7ad0eac6612fdf2e3d2fd9ef5b49e2ef09e41"
    sha256 cellar: :any_skip_relocation, monterey:       "8f397f7c1836625f505b7042c58088d14b179db9e8fbbab0d94e0f04de7cd0cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0b387e8de3b1a0707db87950131e8d84664f997906e40a80a92e8b2f797b5f"
  end

  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "zlib"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/50/a0/f332de5bc770ddbcbddc244a9ced5476ac2d105a14fbd867c62f702a73ee/boto3-1.34.34.tar.gz"
    sha256 "b2f321e20966f021ec800b7f2c01287a3dd04fc5965acdfbaa9c505a24ca45d1"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/18/58/b38387dda6dae1db663c716f7184a728941367d039830a073a30c3a28d3c/botocore-1.34.34.tar.gz"
    sha256 "54093dc97372bb7683f5c61a279aa8240408abf3b2cc494ae82a9a90c1b784b5"
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
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/10/56/d7d66a84f96d804155f6ff2873d065368b25a07222a6fd51c4f24ef6d764/termcolor-2.4.0.tar.gz"
    sha256 "aab9e56047c8ac41ed798fa36d892a37aca6b3e9159f3e0c24bc64a9b3ac7b7a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  # Drop setuptools dep
  # https://github.com/jorgebastida/awslogs/pull/399
  patch do
    url "https://github.com/jorgebastida/awslogs/commit/fd3f785a10ecc8db340813d689a89a1d891fa855.patch?full_index=1"
    sha256 "9660da99d71fcc038a63f72fe0a3acf3901131973ec387a7190647dcf4278304"
  end

  def install
    ENV["PIP_USE_PEP517"] = "1"
    inreplace "setup.py", ">=3.5.*", ">=3.5"
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
