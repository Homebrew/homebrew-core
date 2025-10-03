class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/48/a8/e92a62d609bcc08b2e7afaf97380e50dbff8ccc3c689d3ba4cb56db2bd21/dxpy-0.399.0.tar.gz"
  sha256 "807ec02d82e1153d95c2522403c2b363c050caeae91ec2379ffc6299fb8b9441"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f28428e1d473b45a04ca747aa9881cd5581626987d1f8a1256822c61a8ac721"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c695b75640696a511d39e1de87b507bc66e4fb552a7261cc42cee90597ae04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1125db37e5854fa2ce1a4d05f3068b6b4cafb7d81d978c1b672e5e4f4d8a448b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca4f2e999e03f83fe398fce7b07ff48c0095f4894325b3814f46f15d16f76e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77e301546045002ea570beb451faf290187d988e8e5b84fe99f6591cd6c790c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7211ee5accc21a813976897430526b0577c7f6b2a79e63147789c9f8aeb88e57"
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
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
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
