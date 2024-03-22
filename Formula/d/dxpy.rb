class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/9f/f3/022fe2252a7e894a0478307d0d1cd0ab5912bfd592a6ae8b41b227f2d638/dxpy-0.372.0.tar.gz"
  sha256 "6be5cf0ecd03977c2ad09d863a7de17b6b866cc280ca85dc192612b4fb87da7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b51d5abcdc0f48afd71089c6ed82333c06675ba9b0eecef8f0da190e4b7134aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c607fb3998b9b994eedf31a651e5b85fd5108bfc56f343fab9787f771fa759e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1a424eca4e9d98c579f11c4976cb7a30e36e5bdd761784d91c0bcd6fd53c90"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a25d0bbc0cab61132d8bfd582903e6eed23985da119162a23cf43edbd9cc794"
    sha256 cellar: :any_skip_relocation, ventura:        "cddbdad556272dc540feffa2ea76350aab39b0cd8248e5376e9c8b2d3fe3c708"
    sha256 cellar: :any_skip_relocation, monterey:       "01b13c8591f163df5bcdb36905ca46a8b34a35231c52c2a3818543594db6e182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f829dc11c897e25f78e7dee0004d5773b856b3a0ec3f88fb617812f415cfeb0"
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
