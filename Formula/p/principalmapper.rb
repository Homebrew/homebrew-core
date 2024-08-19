class Principalmapper < Formula
  include Language::Python::Virtualenv

  desc "Quickly evaluate IAM permissions in AWS"
  homepage "https://github.com/nccgroup/PMapper"
  url "https://files.pythonhosted.org/packages/3f/8c/3d2efe475e9244bd45e3a776ea8207f34a9bb15caaa02f6c95e473b2ada2/principalmapper-1.1.5.tar.gz"
  sha256 "04cb9dcff0cc512df4714b3c4ea63a261001f271f95c8a453b2805290c57bbc2"
  license "AGPL-3.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ba66a19c2f3e1a1f23656651819f41e943350d3d4b23e99dfb2779e58881ef5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ba66a19c2f3e1a1f23656651819f41e943350d3d4b23e99dfb2779e58881ef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ba66a19c2f3e1a1f23656651819f41e943350d3d4b23e99dfb2779e58881ef5"
    sha256 cellar: :any_skip_relocation, sonoma:         "a20093b5e9f325981fc15c4fcf75a0f7d623b7ba52449f4715d6dba276b8f4a2"
    sha256 cellar: :any_skip_relocation, ventura:        "a20093b5e9f325981fc15c4fcf75a0f7d623b7ba52449f4715d6dba276b8f4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "8ba66a19c2f3e1a1f23656651819f41e943350d3d4b23e99dfb2779e58881ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d90c4241ac562ef113060f47a93f1d9c83ea55ebbba42f28bcf0e4ed9f5d3409"
  end

  depends_on "python@3.12"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/c9/844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484/botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pydot" do
    url "https://files.pythonhosted.org/packages/d7/2f/482fcbc389e180e7f8d7e7cb06bc5a7c37be6c57939dfb950951d97f2722/pydot-2.0.0.tar.gz"
    sha256 "60246af215123fa062f21cd791be67dda23a6f280df09f68919e637a1e4f3235"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/nccgroup/PMapper/commit/88bad89bd84a20a264165514363e52a84d39e8d7.patch?full_index=1"
    sha256 "9c731e2613095ea5098eda7141ae854fceec3fc8477a7a7e3202ed6c751e68dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "Account IDs:\n---", shell_output("#{bin}/pmapper graph list").strip
  end
end
