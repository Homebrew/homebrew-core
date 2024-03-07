class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/fa/71/2bd268f518591a82400eeccaef4cc11987b6a49912bccbf46339388eb98a/awscurl-0.32.tar.gz"
  sha256 "0c4c91a9c9873e1ad95c37371b63ebf8be20c70722b5fb9cdec430553117594e"
  license "MIT"
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "692fa4ce1184d846de9a33a6c79e63d25d3d1d6fe0d30b7816940dc117087ae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c09759c3419821d62992a55145a1419ecfcc2d373a08b7bb5d8459d20867bf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1000feb4fcc0cd10fceb4904ac8cd6181d6bb7e80bd6d342f57d433142727600"
    sha256 cellar: :any_skip_relocation, sonoma:         "2abc19057d9b4a3a37d95dd0a07c2b9e024e03a16e552a1dc4ba52da1c07c571"
    sha256 cellar: :any_skip_relocation, ventura:        "5341420cfb7591d726a33158d9becb34c03ae375b6816171a6821e35cc4ecac8"
    sha256 cellar: :any_skip_relocation, monterey:       "204e51eda87a881a450779fa9559327db754cb9b7d9ed5de8fff48d76fa73314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc913c2814175a57b646985d9ca3d2e602591beaf5c1d4dcbe2a53ec01b80d3"
  end

  depends_on "certifi"
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/6d/b3/aa417b4e3ace24067f243e45cceaffc12dba6b8bd50c229b43b3b163768b/charset-normalizer-3.3.1.tar.gz"
    sha256 "d9137a876020661972ca6eec0766d81aef8a5627df628b664b234b73396e727e"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/0b/65/bad3eb64f30657ee9fa2e00e80b3ad42037db5eb534fadd15a94a11fe979/configparser-6.0.0.tar.gz"
    sha256 "ec914ab1e56c672de1f5c3483964e68f71b34e457904b7b76e06b922aec067a8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
