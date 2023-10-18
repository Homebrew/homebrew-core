class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 10
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d02c61285d4d857d8876273c23711aabc066492fca692763eed3912a1f697ca8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b138f35a1eb341186dd6dc41c2b1540039dc518bca8e5d8c3d577ee15364b7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "372cc126899ab73e28ee0ccefb7721ec1e450535f9533c896b8b3ff211a4314b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f73d4bd50d29a0994bbd04d77071f435bb26bdd87ddaa6c1110bc9b37ba5f43b"
    sha256 cellar: :any_skip_relocation, ventura:        "9b33377f180d5f5feb8468f613941c3a3d56e841c1dca8830719cc19339c2380"
    sha256 cellar: :any_skip_relocation, monterey:       "1824bdc223addab4fb427d95bb216749c1289123fd39a2ecf9640faa76a7a6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f89c12787051c8f50e274981484d7e5632ac128612c3be813958d2d5ce58c4"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/2f/4ccd05e765a9aa3222125da37ceced40b4133094069c4d011ca7ae37681f/boto3-1.28.65.tar.gz"
    sha256 "9d52a1605657aeb5b19b09cfc01d9a92f88a616a5daf5479a59656d6341ea6b3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/3f/ff/5fd9375f3fe467263cff9cad9746fd4c4e1399440ea9563091c958ff90b5/s3transfer-0.7.0.tar.gz"
    sha256 "fd3889a66f5fe17299fe75b82eae6cf722554edca744ca5d5fe308b104883d2e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end
