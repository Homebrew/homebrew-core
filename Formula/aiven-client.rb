class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/46/b5/38fca92bce202f6c547d709743545eba881cadfe495903d234149f6d360c/aiven_client-3.0.0.tar.gz"
  sha256 "9690d64da1e9306d2308f3f125f347acd6b53db4e7927ef4a7d4c0d1cd2b1b6c"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ffff76e4dfd8c38cfa3f80362dfb91c07376c4fa1d4a50bc694a522750e2d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30d78f9e594e2fadd6f3b809bf00b6fbe7ef636d8b273dd9bc241f407cc4fe3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b79988cfcb826c2bcd69030966cac2f2235d53b6e0d5a7bc2e975f030c7f52"
    sha256 cellar: :any_skip_relocation, ventura:        "f503600a99722a30ab5194ba65f3d304df02b52739787db40d33255614a66fa3"
    sha256 cellar: :any_skip_relocation, monterey:       "15d30ae397aebaf30d186d76a50bd2e8d1b0ec471ba35b3b493a6f88cb9e9dfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "850d5b16cedd4462c533601018fac9c77f98f395d33a64ec393867dbbd017503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c379168f182c67cbc5f04b394bc393292137773123fc6c6475de4f3eaf52673b"
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
