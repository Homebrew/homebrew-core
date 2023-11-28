class Awslogs < Formula
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

  depends_on "python-setuptools" # for pkg_resources
  depends_on "python-boto3"
  depends_on "python-jmespath"
  depends_on "python-dateutil"
  depends_on "python-termcolor"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def python3
    "python3.12"
  end

  def install
    inreplace "setup.py", ">=3.5.*", ">=3.5"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/awslogs --version 2>&1")
  end
end
