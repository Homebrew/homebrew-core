class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/8a/db/f2d29bc2d86109cd5e5f3922621572cc36874502879eace648f743b7f777/jc-1.22.0.tar.gz"
  sha256 "0cb5ba460f0a7e3831005a7520f5a12d831670d705422c7b650b0f843c229784"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e40e7e8d73707bf2ffdcdc89a463de12a0430ae89ba6f67ac7c28bccdc70926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a2ea4c474c44ae9bc56d5fe2901e9a4aef0de0c544190437d576d97c3c6ab00"
    sha256 cellar: :any_skip_relocation, monterey:       "c308d14b1e5462df358dae67af846be563cc0c318de0c693d9278119c71290f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c344b75154eeb24fb709858c9455e59627547940d4940de8375a0ee10a26ac2"
    sha256 cellar: :any_skip_relocation, catalina:       "750e820d9cd42c0254592a1abcb338314182d6db0e8290292e022fc67ceb8106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa42a8c14e6ee3d36bc4d058b9bcfe8628291280f018c5a63c88d64917770ecf"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
