class Checkdmarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line parser for SPF and DMARC DNS records"
  homepage "https://domainaware.github.io/checkdmarc/"
  url "https://files.pythonhosted.org/packages/b4/f3/0e4108ec0939ed21524e8fb2638725cca48ae750a837b09d3f6695092419/checkdmarc-5.5.0.tar.gz"
  sha256 "d775f566f8fdd584adb9a26e792cfe1565cdf6bd50c54fe7b6d8443ce6db68cf"
  license "Apache-2.0"
  head "https://github.com/domainaware/checkdmarc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2345b4fafdd9128b87ecc92d6a47e5f8f507569b26d6c2c1c3cace26fff60346"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2345b4fafdd9128b87ecc92d6a47e5f8f507569b26d6c2c1c3cace26fff60346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2345b4fafdd9128b87ecc92d6a47e5f8f507569b26d6c2c1c3cace26fff60346"
    sha256 cellar: :any_skip_relocation, sonoma:         "2345b4fafdd9128b87ecc92d6a47e5f8f507569b26d6c2c1c3cace26fff60346"
    sha256 cellar: :any_skip_relocation, ventura:        "2345b4fafdd9128b87ecc92d6a47e5f8f507569b26d6c2c1c3cace26fff60346"
    sha256 cellar: :any_skip_relocation, monterey:       "2345b4fafdd9128b87ecc92d6a47e5f8f507569b26d6c2c1c3cace26fff60346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d02feea28f3526840d77660c8bceb901bf22ce1b949c4b12b044981ed7bdf5"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/37/7d/c871f55054e403fdfd6b8f65fd6d1c4e147ed100d3e9f9ba1fe695403939/dnspython-2.6.1.tar.gz"
    sha256 "e8f0f9c23a7b7cb99ded64e6c3a6f3e701d78f50c55e002b839dea7225cff7cc"
  end

  resource "expiringdict" do
    url "https://files.pythonhosted.org/packages/fc/62/c2af4ebce24c379b949de69d49e3ba97c7e9c9775dc74d18307afa8618b7/expiringdict-1.2.2.tar.gz"
    sha256 "300fb92a7e98f15b05cf9a856c1415b3bc4f2e132be07daa326da6414c23ee09"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "publicsuffixlist" do
    url "https://files.pythonhosted.org/packages/71/10/dc631ba57b47dbf61d5190302a767a2197854c838ddb251737ee13760ff0/publicsuffixlist-1.0.2.20240814.tar.gz"
    sha256 "dccebfc980f6adff5be82a62e2ab14320c6498a339ef6519bf35548253edcb4a"
  end

  resource "pyleri" do
    url "https://files.pythonhosted.org/packages/93/6a/4a2a8a05a4945b253d40654149056ae03b9d5747f3c1c423bb93f1e6d13f/pyleri-1.4.3.tar.gz"
    sha256 "17ac2a2e934bf1d9432689d558e9787960738d64aa789bc3a6760c2823cb67d2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "timeout-decorator" do
    url "https://files.pythonhosted.org/packages/80/f8/0802dd14c58b5d3d72bb9caa4315535f58787a1dc50b81bbbcaaa15451be/timeout-decorator-0.5.0.tar.gz"
    sha256 "6a2f2f58db1c5b24a2cc79de6345760377ad8bdc13813f5265f6c3e63d16b3d7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/checkdmarc -v")

    assert_match "\"base_domain\": \"example.com\"", shell_output("#{bin}/checkdmarc example.com")
  end
end
