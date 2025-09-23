class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/98/44/f0bd42415231c102ea570809cfa96c8ce95c9eb01b0768445c4e9c62a2f2/dxpy-0.398.0.tar.gz"
  sha256 "9d4254f9366a2126d8c0d47fc613decde832de13875b6f4bb09e19f14b830fe3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "570f5f5b982d55578d8f24ad53992a82b0b69d5990947980f2e7b598f3947798"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c0af6fb9090423fb514204e07ce77ce72ee6e537544d8d87962d04ea14c921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d035248538b7cf0f64992dc08426d106a2800ba6a3f2d3b95d3190520f88eb61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "176b311f09f2cbf21d8f5316dc1f32c04040b6bdd249a071f0530a2cc374c304"
    sha256 cellar: :any_skip_relocation, sonoma:        "6634c3c0ff84dc553b8a8a4ce617b097ff951d0d4cee78b4aeceddd0e4203cfb"
    sha256 cellar: :any_skip_relocation, ventura:       "2b7f0d3e7926591ce789e1a7248c09f5cd36a3e1abe14b5831f567e7f6e57ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30bc2e8afaf7c9da3787ced580e9f86834508d2199a35f51375adc554ab35f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddcc46514e1a84054f603d5d88c84de9872ac85f18963ecbd1dd376a69590eb"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/7f/4c/4e40cc26347ac8254d3f25b9f94710b8e8df24ee4dddc1ba41907a88a94d/crc32c-2.7.1.tar.gz"
    sha256 "f91b144a21eef834d64178e01982bb9179c354b3e9e5f4c803b0e5096384968c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
