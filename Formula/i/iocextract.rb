class Iocextract < Formula
  include Language::Python::Virtualenv

  desc "Defanged indicator of compromise extractor"
  homepage "https://inquest.readthedocs.io/projects/iocextract/en/latest/"
  url "https://files.pythonhosted.org/packages/ad/4b/19934df6cd6a0f6923aabae391a67b630fdd03c12c1226377c99a747a4f1/iocextract-1.16.1.tar.gz"
  sha256 "ec1389a76a5083f643652579610e8313d27ed5821fc57e7b046c23ddec181d44"
  license "GPL-2.0-only"
  revision 5
  head "https://github.com/InQuest/iocextract.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4419c83db2e567cc8a97b984e08b57a5866f202a6714492be2cdf5b26a52daf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5e2c6a4700849d4be490edf2a72bbc3e67e36fc986fa507ff230c21abd2d95b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ad96eabdd5c5c1bcc10a6702dcac4cdb8e9e98a1a4efc35f08ef85347ad5464"
    sha256 cellar: :any_skip_relocation, sonoma:         "8682b6dd588284ecb53ab333b02a0fbf9ea6c691dd413b39a6c3c018937db365"
    sha256 cellar: :any_skip_relocation, ventura:        "4211cfe7dd035b4cea2e7a2be3f4706717e4596d3d90b3d70d0441ab3a0b7084"
    sha256 cellar: :any_skip_relocation, monterey:       "70b1b642ba119dd86225a727e75dc737f0af36d2cfa79ff2f26f3fc843109610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1866920caaf723e1683e579048c72645cad1c5ffbbf32eb6f2b3dbde044f9917"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/7a/db/5ddc89851e9cc003929c3b08b9b88b429459bf9acbf307b4556d51d9e49b/regex-2024.5.15.tar.gz"
    sha256 "d3ee02d9e5f482cc8309134a91eeaacbdd2261ba111b0fef3748eeb4913e6a2c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write <<~EOS
      InQuest customers have had detection for threats delivered from hotfixmsupload[.]com
      since 6/3/2017 and cdnverify[.]net since 2/1/18.
    EOS

    assert_match "hotfixmsupload[.]com\ncdnverify[.]net", shell_output("#{bin}/iocextract -i #{testpath}/test.txt")
  end
end
