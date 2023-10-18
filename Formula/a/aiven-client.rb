class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/27/05/bdde8a0a85a59e06cc243e07145884ab58fe50540f957ce5ee3d9dedce52/aiven_client-3.1.1.tar.gz"
  sha256 "421a00c9955b8704812395cc7add3bacb03977657cd87391028fdb9894252509"
  license "Apache-2.0"
  revision 2
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f0685afa8fd36c8aeb07017f34bd6f22256a16460aa3037ec5652d66a06aa08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1969555a9cd95189706686550b47778683abbc444b7312eaa0dfa9779c8c7fa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e1dab1f707cf36c4b45302bee460f3b1dd597501af9bcfa1f81e40c1cbf558"
    sha256 cellar: :any_skip_relocation, sonoma:         "df2644ce8aa19d1ea76ff865f9f637a8d8a4717044dca367a80b6fb6fb2235b3"
    sha256 cellar: :any_skip_relocation, ventura:        "3c03f06d8901d52dc4e1deb39d62c1be50ca0c6dcb3f66a4935b0bae0a258a07"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea6b7ce435a23cd9e7aed4dc622d2bffae5b7f8ce0921903c159437ac7b0db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821f9ea110f4bfc928376e4f4e616888d0793ddb835cf299b7ebd9198ea260c1"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
