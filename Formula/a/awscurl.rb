class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/58/b0/470fb7df0d814dee820ae21fd9b117da5b012e0247f2791ddfd2c3584dc3/awscurl-0.30.tar.gz"
  sha256 "7938fc270d0cc7b9c92fff0670406e0b21cc343724930136c24fdaf0d938cc80"
  license "MIT"
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce2243c8bca9901443f71077ab655a37455882aa08998e27f3970dba197c06ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb446ce49bb5f586089bfb7ec9891eb1f4145326cda31ae4698e35223f784ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a96e8dd3abbadcc7431a9c2cc2c60c3f94ec44ddbf038764e752fbdafb5e1ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f2a35c5480db6fef5cde0ae97369e2d90ac27ed79682a4660c9be4a4037a5e7"
    sha256 cellar: :any_skip_relocation, ventura:        "89c50079919c1ff8744606d2a5419037a63aa1071e3a26535965dd6d01ac4c43"
    sha256 cellar: :any_skip_relocation, monterey:       "d54fa8c6461325d2b84e2e73204599f8ac7c9a9b9f807d730d30cf4d1cb61d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94abe6668915d1193bfbe10586d2f18ef09aa9eee330020fcb760a593c026f09"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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
