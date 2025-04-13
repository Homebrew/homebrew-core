class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/a3/01/2a986db11c0668393c19cbbbef70ed54b8f6172bc825b9228adfd38417cf/dxpy-0.394.0.tar.gz"
  sha256 "6ba10417b0907f80c2ef1049f6799014cd8fce69654cbd8d3dcc2823d30f7892"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55446b59af45a9c31c4792e927c82b50fb2f4126edf3ca0cd7ddcaf23b89a604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bcd1680e62ce94f30b496efc99533967a0506f77ab2e1db5a86220686e90e48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "905aa639d684e3b7284072d25e694a6a299eb41dbac1bd49b604f0c310103da6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb2efc305f8b1baeee60f28636e472980c36389ab45d09828a6a22d2500d361"
    sha256 cellar: :any_skip_relocation, ventura:       "2d45de222d352db18a58de029606c2fc9dcab8963d5b55e02f73e2a24cc61aa3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeea44f45568f22ef9b0e4ad05f1fd20c59502a257e8d4c8115fcc7abb5cb8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630e857f60399d5b7742982dd98cba07c3aa010a992f68bdbb9abf3b994768b0"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0a/35/aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39b/argcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
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
