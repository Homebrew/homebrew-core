class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/25/f9/023c80ea27d67b0930f116597fd55a93f84de9b05d18b38c7d2d5d75c1c9/awscli-local-0.22.0.tar.gz"
  sha256 "3807cf2ee4bbdd4df4dfc8bef027f25bde523dcaf8119720f677ed95ebba66a4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a1a6d14ba1703b371655f76fbd4e3c1fc1a5305c0057d88a248bb3574941419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e7f0f292f91a43f0826a27fc78d4777658613b479fdb2598e2e88ffcff9efab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80cbb97d4adb633da5a90cc933e124e59ca87aae5941d073b76cafa8644a95f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b25d7ab6accf7b1ce62b0e040dab8e378cc258dd19dab67a48c4147d4496928"
    sha256 cellar: :any_skip_relocation, ventura:        "4618ee7cf772cd6ffaf99eb4d6f4b0ccb25b04478a4b3d943c6a993cd4eaf20d"
    sha256 cellar: :any_skip_relocation, monterey:       "a7d804ed824d80a78a14bb8a9d718bc0add1d660988e891d67200b72f7f5c1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da3c9208ffd1f92e21f67a1de1b2e5c351f110b7b02721454cde00136e8aa1f3"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e2/8e/75c1e586b46f0f324175253a35265769d60f66934b8a397a027aa7d1a989/boto3-1.34.51.tar.gz"
    sha256 "2cd9463e738a184cbce8a6824027c22163c5f73e277a35ff5aa0fb0e845b4301"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/74/75/fe7eb7a170d9a1a8a2ae93e5bfaa17cbbb308e90da7bfaa28145252fd307/botocore-1.34.51.tar.gz"
    sha256 "5086217442e67dd9de36ec7e87a0c663f76b7790d5fb6a12de565af95e87e319"
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
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/a0/b5/4c570b08cb85fdcc65037b5229e00412583bb38d974efecb7ec3495f40ba/s3transfer-0.10.0.tar.gz"
    sha256 "d0c8bbf672d5eebbe4e57945e23b972d963f07d82f661cabf678a5c88831595b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/awslocal kinesis list-streams 2>&1", 255)
    assert_match "Could not connect to the endpoint URL", output
  end
end
