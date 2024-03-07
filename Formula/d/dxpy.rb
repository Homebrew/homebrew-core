class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/72/48/32516ba7d922e7e7b92b2527cb29f1c948743c193874fb48426caddd6ffd/dxpy-0.370.2.tar.gz"
  sha256 "7cb494300e8ae195ff0551708838a2fdaf5f5f68e4575e9014e9749e7186fbc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83b7c3a6f83f8269dd08b1d07a52afd94bb7a6e7dd6a6084ebcfda9663b6082b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e83d1156b37edd0ec410c3075e32543e6a888e6de92c4a8ac0a653fcd2406690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "912d2586822c2c6e39e835c354ce13ab51bc14a5e396be8b93c840e3a6caf7ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab66e4a499cd72ee36d7ef7f9985f31e98c0305b13bc9731edb27c763d07758a"
    sha256 cellar: :any_skip_relocation, ventura:        "53338cb359f29a3eb1e9666a1d65fcdbc296dcd873cb2da70ca1d8a5bd205409"
    sha256 cellar: :any_skip_relocation, monterey:       "722bb5cbf95bd32331daf00a89203a89d00c2485b675411ff7443e64764e64d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c68a9d1bce87e75c8ccc884f30498c2541f4b06fbde81c719d49298c5fe08b6"
  end

  depends_on "certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/f0/a2/ce706abe166457d5ef68fac3ffa6cf0f93580755b7d5f883c456e94fab7b/argcomplete-3.2.2.tar.gz"
    sha256 "f3e49e8ea59b4026ee29548e24488af46e30c9de57d48638e24f54a1ea1000a2"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end
