class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/fc/22/74984b062b32a812e86db7c9c6ae1057452557b1a5964ef8f3cc4cb80beb/dxpy-0.383.1.tar.gz"
  sha256 "377af4014a5f27efd6fe9478d0fa9c30ced245947fbd2e2e5713c8a37db598b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eebd284f9542ed0f50ab74654d66975033c17d16174be4d10a599f3688e29f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18de10c7e7e81d561d0c954cce65e57fd0a0643b18616a7ea272203ffea960be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e0bae965a77df14276fa90d48f346658a508cd7fe6e1f5f9e160ac5d8d75dc11"
    sha256 cellar: :any_skip_relocation, sonoma:        "20553d5c4decd346b93e3bf62fe3310f688842eb0a14cf6639dca3ed420fdddd"
    sha256 cellar: :any_skip_relocation, ventura:       "736f5a6f35b8a7af98e15082a3239b94bd056cf540fb73de6ea4a12354931ec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9340f0b9506c02f67f675f90fd69e274281f62da53a0ff8cdbf6a1f78c23e4"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
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
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
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
