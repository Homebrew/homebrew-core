class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/27/05/bdde8a0a85a59e06cc243e07145884ab58fe50540f957ce5ee3d9dedce52/aiven_client-3.1.1.tar.gz"
  sha256 "421a00c9955b8704812395cc7add3bacb03977657cd87391028fdb9894252509"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46cdbbd41f6f6af1fd800435cb6511c7d32bb574b6d262d3a2f52960a9792c7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7091ec3d90be6d5adf419aeda57e0b4c0736e23909d55d17b372731600809ea6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "254c45f94e28baaa9b7fa8149f8d7a9c3eb49505b5d93152df8fa5a53c1f804f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7e5401598e2f8efb7f0f21963ae6957afc909a8cd89a83e6dd66b9886ead346"
    sha256 cellar: :any_skip_relocation, ventura:        "77e8151f5511e6ba444aadb85baa3e88a516e5379a82af6172f858771e3e731b"
    sha256 cellar: :any_skip_relocation, monterey:       "009187ab4dccc4d231c11b511c5344f498a18913d2dedae3a4567de872aeeb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e438338c91e0b0156633015f62d5eaa08bde64f27e119c609051e49bd6cb20"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
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
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
