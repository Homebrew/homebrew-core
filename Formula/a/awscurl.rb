class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/71/5b/9a3e05e574b45e99033db5984a1ba6cbb1ad9f422dc63789b18e16af77e4/awscurl-0.33.tar.gz"
  sha256 "9cc47a97218992206af322bd71c7db4e6c8f5635c45d8045578e616c7c83e6cd"
  license "MIT"
  revision 1
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62094501216d15ace887533df9fad35734a2fe01f6193f35d5772fa3c2533b7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62094501216d15ace887533df9fad35734a2fe01f6193f35d5772fa3c2533b7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62094501216d15ace887533df9fad35734a2fe01f6193f35d5772fa3c2533b7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "62094501216d15ace887533df9fad35734a2fe01f6193f35d5772fa3c2533b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "62094501216d15ace887533df9fad35734a2fe01f6193f35d5772fa3c2533b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "62094501216d15ace887533df9fad35734a2fe01f6193f35d5772fa3c2533b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b2b8f59d6d5b752486b9a54dc422307465af3cb598b9c15608de1f4e8a0843"
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
    url "https://files.pythonhosted.org/packages/82/97/930be4777f6b08fc7c248d70c2ea8dfb6a75ab4409f89abc47d6cab37d39/configparser-6.0.1.tar.gz"
    sha256 "db45513e971e509496b150be31bd67b0e14ab20b78a383b677e4b158e2c682d8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
