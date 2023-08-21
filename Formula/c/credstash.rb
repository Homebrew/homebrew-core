class Credstash < Formula
  include Language::Python::Virtualenv

  desc "Little utility for managing credentials in the cloud"
  homepage "https://github.com/fugue/credstash"
  url "https://files.pythonhosted.org/packages/b4/89/f929fda5fec87046873be2420a4c0cb40a82ab5e30c6d9cb22ddec41450b/credstash-1.17.1.tar.gz"
  sha256 "6c04e8734ef556ab459018da142dd0b244093ef176b3be5583e582e9a797a120"
  license "Apache-2.0"
  revision 8
  head "https://github.com/fugue/credstash.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b86ad1d335d4746f547947fc9b42ce6addc5f1c29463c8218c15fc334c8e1715"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f77105f741e79810e8dfba34cacd76a0f9966426815b62c408fec2bba5348fb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0391a96475de52009bc689bbaa4472a876a79d211873a89a4038d5e75087d75"
    sha256 cellar: :any_skip_relocation, ventura:        "2986114fe1b33be3e0122e3810e14b4efa2486028b2cc99500aca94f448def5b"
    sha256 cellar: :any_skip_relocation, monterey:       "126c705b846615953eae6057d205728c479236eeb8081c23203022aadd2ac273"
    sha256 cellar: :any_skip_relocation, big_sur:        "386372a295a6b8a73f1f1f6824e70d5ceff72be362c442f82f79495894ccf177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e8270eec392ff8bb5d99862f81a9dd3d8831c22fcd2992d0175ede9b4ad3ad"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/1b/f9/889e0c7d07bc5616d193d63b9600145d2d83f21a09fca40be078ef9323eb/boto3-1.28.17.tar.gz"
    sha256 "90f7cfb5e1821af95b1fc084bc50e6c47fa3edc99f32de1a2591faa0c546bea7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/54/ce/3aced9653aa3b81aeda70574f342cd3014ecc36aff6a20e74c767f92864f/botocore-1.31.17.tar.gz"
    sha256 "396459065dba4339eb4da4ec8b4e6599728eb89b7caaceea199e26f7d824a41c"
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
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
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
