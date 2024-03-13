class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/c7/34/bf1b1876d7ba5a95abd56fced3f84ed2c5e9f36694897bfa347cfddf752e/dxpy-0.371.0.tar.gz"
  sha256 "d264d06c9101877e5d185c9b3165a19c0d8c5af4bdaf1c42530ad316c53188ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87c6a4858aabefdbab7b3a6d81d5c21042e46926e35883cc0a8343c9eccf41d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b654241e98ecfbd4e808838af5eaddcd9e8d4176a8343f054fb498102615b96b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20b1e899dbe7bf734733c5751f753525dfc8c7bbc1420c2b14d8a89d18a0536"
    sha256 cellar: :any_skip_relocation, sonoma:         "88797a2c66c00e4ac8d5a740a1128a2309b35eb799546f2927696619f44a70c2"
    sha256 cellar: :any_skip_relocation, ventura:        "168bc68ceba526b1578be8424967e47e685cc4b86e93d33278a15273f345d16a"
    sha256 cellar: :any_skip_relocation, monterey:       "d989f45b061ff7d42c208015969258226460bcbddda589b8d8e40b1ec15a9d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c03dd9025cad4d67464f3b7b1969d9b80a67ae32a9b61382720e84ed63c2b1f"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/3c/c0/031c507227ce3b715274c1cd1f3f9baf7a0f7cec075e22c7c8b5d4e468a9/argcomplete-3.2.3.tar.gz"
    sha256 "bf7900329262e481be5a15f56f19736b376df6f82ed27576fa893652c5de6c23"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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
