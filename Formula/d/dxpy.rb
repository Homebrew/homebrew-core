class Dxpy < Formula
  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/70/38/ffe0f40f320401900446a93d74f4462848c2288b1d27e342589bdc8a52e3/dxpy-0.367.0.tar.gz"
  sha256 "21491f943b3cd1aeb5d0ad33b8f5e269653c43f23ce796b129c93599204d7caa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0147d7b87971af8bdfab8eca5a08d80bfc4e197aa2dded78afb7a3295bab4fbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f0b45385adf89d07f2c16b7630a8c144026ab785571b5a77c89228c511e7f89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eed1b543ea207744ee1625d19228838c78aa244dfd4725dc093dfe1749abf32"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d55ee165ce7fdcb47b96ff746e2379d4295eff82df557a8545efcd17c4b1211"
    sha256 cellar: :any_skip_relocation, ventura:        "5c16f46c84fa707c08811de000281608faaef08d3f7350cb8b81a53416ddf89f"
    sha256 cellar: :any_skip_relocation, monterey:       "4f7c8bd0a0a098a81ad5edf2c2231c7ab1b9da414693e175e193de2fd005b08e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e65c9797d806f9f6ef99ad835b9241f1e0dd5309d8c634b8f8dda9b6e378a3f"
  end

  depends_on "cffi"
  depends_on "python-argcomplete"
  depends_on "python-cryptography"
  depends_on "python-dateutil"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python-setuptools"
  depends_on "python-websocket-client"
  depends_on "python@3.12"
  depends_on "six"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  def python3
    "python3.12"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/d4/91/c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28/certifi-2023.11.17.tar.gz"
    sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."
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
