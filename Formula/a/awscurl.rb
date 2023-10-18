class Awscurl < Formula
  include Language::Python::Virtualenv

  desc "Curl like simplicity to access AWS resources"
  homepage "https://github.com/okigan/awscurl"
  url "https://files.pythonhosted.org/packages/09/5b/98f022bc96ceb68b12fb4cfe6fdf52cc3051fa0b7bf51dc805521afe72bd/awscurl-0.31.tar.gz"
  sha256 "6ce032543c0ec00857ce9c08cafe8041270b5508b08ec73e264e63f1e1255601"
  license "MIT"
  revision 1
  head "https://github.com/okigan/awscurl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a55974060f69e84b9fc9b507be2b9be3cc9f79ee8e2ee89dfe4c962580f8d934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0810425114ae89adfb02068cb106fe8518ae9b7f35b67392724c093c3c41c384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "970f6678fdbfe8e0cbecdd5a354a982eb4e9cd818060d4b68768db97ce8e8e5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7d794cf2b354e2f627a5965fe26413d4153b5a7a0cdc6070032eeac6cc8e8b8"
    sha256 cellar: :any_skip_relocation, ventura:        "9160b480de144b1423f19ab0df8e824c832870980ddd8929709b94a51866dafb"
    sha256 cellar: :any_skip_relocation, monterey:       "254e3c98b37430acecc91a5c89d5cde6efbb02653adf65360011f0144517f6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e1eac66005d85821321079180fb955390bcf1331e3ea47a0df36a01b8908e3"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

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
