class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/27/05/bdde8a0a85a59e06cc243e07145884ab58fe50540f957ce5ee3d9dedce52/aiven_client-3.1.1.tar.gz"
  sha256 "421a00c9955b8704812395cc7add3bacb03977657cd87391028fdb9894252509"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32e5bf7ce5041eb5c43e1e69d173f272f696d45e186bae09aacd21678de01ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7c16f9dbfd52d600d7b400b2a3571ef389d18d627fbe32219ad47083e03936a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f92d8ad9582026d3471263fbe23a303b417b250b0da77cc0f8eedf1c018a4fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c02141476bbc4e43ee80fb6a24515068c3375b31d2bc2a459aa96ae5dd949a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "02b21259e52064886d8e08d5b8e12789974bb5071edd292b88a1d276162e5bfe"
    sha256 cellar: :any_skip_relocation, ventura:        "e066461ad2d864184d333b4b79d8ac88fc7dcc01b00dadb356104a8734865efe"
    sha256 cellar: :any_skip_relocation, monterey:       "5aa10a0dbe616ae15a67804b890678394835b82f8c60b866e8d7d4bcc3063841"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e5ad7dd0115793bb9a5bb54a4255635ee3ff2581bb72cb5ac2073233dc95577"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e1e98cea896ce9bae947f62a42f05e218914456afef4ea47c4074c45f90ef8"
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
