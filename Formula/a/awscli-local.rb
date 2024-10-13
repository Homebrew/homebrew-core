class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/25/f9/023c80ea27d67b0930f116597fd55a93f84de9b05d18b38c7d2d5d75c1c9/awscli-local-0.22.0.tar.gz"
  sha256 "3807cf2ee4bbdd4df4dfc8bef027f25bde523dcaf8119720f677ed95ebba66a4"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9aa33640117c9c11d1c5d15efbc13f38a596d0bf0187b9b13b0ee719357227ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db5e119a2b5ccca2f51384cce154572769410afab93432965bdcad8f97700972"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5e119a2b5ccca2f51384cce154572769410afab93432965bdcad8f97700972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db5e119a2b5ccca2f51384cce154572769410afab93432965bdcad8f97700972"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a0c31a12aad8d73d4d569a2d43462563cc1d4ffab1bfe0bfee7cb56a3a2e376"
    sha256 cellar: :any_skip_relocation, ventura:        "0a0c31a12aad8d73d4d569a2d43462563cc1d4ffab1bfe0bfee7cb56a3a2e376"
    sha256 cellar: :any_skip_relocation, monterey:       "0a0c31a12aad8d73d4d569a2d43462563cc1d4ffab1bfe0bfee7cb56a3a2e376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047c13425215e180d3bbc570d03a766881235369cceb1d45ad50daa00d0cc4e7"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/81/f5/0c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455/boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/c9/844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484/botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/ce/f6/7c19f1249cdcdc946616387e8aa93472f879624eb6acdd31a78a76fc046f/localstack-client-2.5.tar.gz"
    sha256 "8b8b2ee6013265a55d3e312a4513efccd222131bed79395545a4f643704f9213"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end
