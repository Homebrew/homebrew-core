class AwscliLocal < Formula
  include Language::Python::Virtualenv

  desc "Thin wrapper around the `aws` command-line interface for use with LocalStack"
  homepage "https://localstack.cloud/"
  url "https://files.pythonhosted.org/packages/25/f9/023c80ea27d67b0930f116597fd55a93f84de9b05d18b38c7d2d5d75c1c9/awscli-local-0.22.0.tar.gz"
  sha256 "3807cf2ee4bbdd4df4dfc8bef027f25bde523dcaf8119720f677ed95ebba66a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e67b9e8c81cdaea08859b60369a1e7198064f0b652a52fafe71aa408f3c6bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cb5ca792f0e064403dcde031e0fb0cec34b79202b8af8aede616eab29dcd3c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17d15ef2e803bdfdf6c5ef4c57a520aa9b8811532d34cd5847660ddb7fe78f98"
    sha256 cellar: :any_skip_relocation, sonoma:         "692b6de0c929a80d93af90b64af2e64c452c906b5fd975028e64eaff87356574"
    sha256 cellar: :any_skip_relocation, ventura:        "5e7a3b823d77ac4f59034dca76720f96a3a69ac244176c2787a7146fd9ae44d0"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae6bc304c118b14dbbeb70cf554007c24234de0129f3a47ff1ebf57735fd47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8bbd3065d0b0ce110256926a0714afc9871fd0793be11d01c253255cab3172"
  end

  depends_on "awscli" => :test # awscli-local can work with any version of awscli
  depends_on "localstack"
  depends_on "python@3.12"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/b5/5c/1d529b3dde18e48778f0b4a39c1b8309a1d4346103aa81d69fe1eb3f65f1/boto3-1.34.11.tar.gz"
    sha256 "31c130a40ec0631059b77d7e87f67ad03ff1685a5b37638ac0c4687026a3259d"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/41/19/6a5eda9547aca880db17f685f385ca48d09df8dde0ee6dc738c7cfb06c21/botocore-1.34.11.tar.gz"
    sha256 "51905c3d623c60df5dc5794387de7caf886d350180a01a3dfa762e903edb45a9"
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
