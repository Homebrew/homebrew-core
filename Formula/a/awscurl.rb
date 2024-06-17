class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/71/5b/9a3e05e574b45e99033db5984a1ba6cbb1ad9f422dc63789b18e16af77e4/awscurl-0.33.tar.gz"
  sha256 "9cc47a97218992206af322bd71c7db4e6c8f5635c45d8045578e616c7c83e6cd"
  license "MIT"
  revision 2
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42b6721c0996f8420a4438d66d102ed3c5cd9d3c9bbefef1bcccdd67decb2adb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f99172781a72ca1a178b55ecc231f8c9e101d800559eda3c2c8adc465ae554d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db0ea964e3c21cca8c668477d6c2d9f80ca5edec653bdcbf38ee6d2a051d38f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fe538b38a3024dbf26c9be7622e036d252aac7608dd8b1c15a93bf2ad5e9ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "28b0120703b8365fb28261c8448d916e0a7e8e9676a59a798289ca1b70393c96"
    sha256 cellar: :any_skip_relocation, monterey:       "5bf2a55d76eb556e21a827914afc3aa508e27ba86fdb08de460d4b45bacbd29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfed102e618d6d6207419cb2b413d68eab571a2d6343b0ff0856affbd3ed6b6"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/fd/1d/a0f55c373f80437607b898956518443b9edd435b5a226392a9ef11d79fa0/configparser-7.0.0.tar.gz"
    sha256 "af3c618a67aaaedc4d689fd7317d238f566b9aa03cae50102e92d7f0dfe78ba0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d8/c1/f32fb7c02e7620928ef14756ff4840cae3b8ef1d62f7e596bc5413300a16/requests-2.32.1.tar.gz"
    sha256 "eb97e87e64c79e64e5b8ac75cee9dd1f97f49e289b083ee6be96268930725685"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Curl", shell_output("#{bin}/awscurl --help")

    assert_match "No access key is available",
      shell_output("#{bin}/awscurl --service s3 https://homebrew-test-non-existent-bucket.s3.amazonaws.com 2>&1", 1)
  end
end
