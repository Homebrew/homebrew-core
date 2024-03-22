class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/21/c2/3b05dce5bfce7fa1081ee460002ecf65e66349c49767c17cc423f0ab9e68/aiven_client-4.1.1.tar.gz"
  sha256 "f2ccd6b140cfd86765e81cfcc2a949f030d9ec494b2c32802105d91b47e15ee5"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f9e9b2d4f07d8aa716771a007589e6005c3f7ae3a6dde8ebd0287a4a383d8b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9e9b2d4f07d8aa716771a007589e6005c3f7ae3a6dde8ebd0287a4a383d8b8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e9b2d4f07d8aa716771a007589e6005c3f7ae3a6dde8ebd0287a4a383d8b8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9e9b2d4f07d8aa716771a007589e6005c3f7ae3a6dde8ebd0287a4a383d8b8a"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e9b2d4f07d8aa716771a007589e6005c3f7ae3a6dde8ebd0287a4a383d8b8a"
    sha256 cellar: :any_skip_relocation, monterey:       "f9e9b2d4f07d8aa716771a007589e6005c3f7ae3a6dde8ebd0287a4a383d8b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27d2dc59adb2a1db5020f9c6008572213a87f26ef51c834005f740dbde76b356"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
