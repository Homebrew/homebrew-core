class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/46/b5/38fca92bce202f6c547d709743545eba881cadfe495903d234149f6d360c/aiven_client-3.0.0.tar.gz"
  sha256 "9690d64da1e9306d2308f3f125f347acd6b53db4e7927ef4a7d4c0d1cd2b1b6c"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1114db2e1fa298621b64917733948b0bf9f309d15776f78e410dec1462d40ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b64f807fac89efce3d5f05e9008f7a50a87de6aaea412e82839acbd26bd3f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac1e4910d44541c175a43bf7ee4410f9bf49c1d4f04267ca0f030633fa71172b"
    sha256 cellar: :any_skip_relocation, ventura:        "ad1ced31f9ccfaa1ef175144ce184f5961ec1dbbc99405f3566cd67cf621e3de"
    sha256 cellar: :any_skip_relocation, monterey:       "69b5f1049ff6b4876106abb944380b56577c7c310dc8e552ce4058d635dcfbf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "092c2f976fe2df1d327b9624f200833328ec5ef7f39ac957045a121d7805bba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8b1f774ba2c0c9aeb4a02db5d0d7c22a288063173afd14d555ae10168461ac8"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
