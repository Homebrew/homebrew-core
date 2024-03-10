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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "580e1ab92587f434de9ab6919e5a1f3b5157dada866c874209dfd5793d539695"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9d6ac074cdf858ddad834f040396d2a3f27f330ce5366d6d656dd59a07b5d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77fa7f16ccbdedef39fcf492a8d41eb681b6fdc12912bf2decedf9e56d6067e"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a2891381f0842f997e9e76e6b6c7d7b66525e520c1f8e25f0b90a8d895e15fa"
    sha256 cellar: :any_skip_relocation, ventura:        "5514de528c11cd086bc0d6cf427c0252d18cab00372d9877dfd942599dee19f4"
    sha256 cellar: :any_skip_relocation, monterey:       "a640a6cb1cb658eb3d7558390d965d80f03afd2ded2cf3c4e9db7859f356348d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "862e054287f07b02d9fdaac6ed7722cf33a5ad27d68f6d0408df473eb6bc4be3"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/dc/d1/23a7ed157ca950a344b2ef814db01c175f970320c4bf1be364ca0c1afdd2/boto3-1.34.50.tar.gz"
    sha256 "290952be7899560039cb0042e8a2354f61a7dead0d0ca8bea6ba901930df0468"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/48/af/d038bd03233fe5c009fd67e8e1bfa6536c3b2ab91737cc629acbff464aa3/botocore-1.34.50.tar.gz"
    sha256 "33ab82cb96c4bb684f0dbafb071808e4817d83debc88b223e7d988256370c6d7"
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
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"
    output = shell_output("#{bin}/credstash put test test 2>&1", 1)
    assert_match "Could not generate key using KMS key", output
  end
end
