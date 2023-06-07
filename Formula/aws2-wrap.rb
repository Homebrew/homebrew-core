class Aws2Wrap < Formula
  include Language::Python::Virtualenv

  desc "Script to export current AWS SSO credentials or run a sub-process with them"
  homepage "https://github.com/linaro-its/aws2-wrap"
  url "https://files.pythonhosted.org/packages/db/07/db4c98b4d44ee824ad21563910d198f0da2561a6c7cfeaef1b954979c5c6/aws2-wrap-1.3.1.tar.gz"
  sha256 "cfaee18e42f538208537c259a020263a856923520d06097e66f0e41ef404cae7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b674a21c0c093399bb3504de8754e55bf91f6048d09fbee714e6149b5e9592ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afe746e339b4a0035b736be16c901ecce4cd3559db5c228bdebb37003df6bce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "010f352e8abd3811461df22ce194c88d8af2d69815b9aacacc5eff6dec5b1204"
    sha256 cellar: :any_skip_relocation, ventura:        "3a16f4a02da618252eb33ca6d15c7f80128155e23774ccdd17ad14f67f833666"
    sha256 cellar: :any_skip_relocation, monterey:       "67da428ede437becefb978d6c57f798e9e6d0e9751e88c2a8f66ee012955d432"
    sha256 cellar: :any_skip_relocation, big_sur:        "2edae4d6d8b898ad8057b266256491615ac0832d09fed2209ca30acfebe9aa15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0c88329279ed6319346d0363bada116a907de02f65c56e4ebe4c8774c0995c"
  end

  depends_on "python@3.11"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    mkdir testpath/".aws"
    touch testpath/".aws/config"
    ENV["AWS_CONFIG_FILE"] = testpath/".aws/config"
    assert_match "Cannot find profile 'default'",
      shell_output("#{bin}/aws2-wrap 2>&1", 1).strip
  end
end
