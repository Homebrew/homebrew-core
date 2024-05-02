class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/85/d6/017034638b717a401294f1212fada01c2189898ca684ea1fa37d396032ba/dxpy-0.374.0.tar.gz"
  sha256 "2e1f049d28815ae7c3a67f4e2302bc9fe23bd235780c927b82122d52badf9fcb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "971672387605d0dd512d4d65284e68d7a26fbe1452746addcdd4fd522f5e9ea1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a13f9b27a45cdbdec4d4caceb9ca4285421a5cc1e35c8e451f656ea703ee38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0653c1227a665ecde80686c69ef575692430935e343b9e0a847f9e34ff811ea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7cc9ca4e97fc4d2f60d7bf6d8ef84c0266b2539916d67b88f7e6ded903a335d"
    sha256 cellar: :any_skip_relocation, ventura:        "5291b26680c5cb74e3c1844b4500fd22789d26b94dc965567efc9cd0c7dccc66"
    sha256 cellar: :any_skip_relocation, monterey:       "8fac0031a88f456083fffc4e0a5a1d3a003df19b61d7347a86f6e2be7db9f2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bccca5543eb059686492d6d4c0a9c3cbb6ccea3f8d1c332d198526f4060645ba"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/79/51/fd6e293a64ab6f8ce1243cf3273ded7c51cbc33ef552dce3582b6a15d587/argcomplete-3.3.0.tar.gz"
    sha256 "fd03ff4a5b9e6580569d34b273f741e85cd9e072f3feeeee3eba4891c70eda62"
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
