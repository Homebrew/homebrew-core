class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/dc/b6/97e3c3e4b61290452d6967f36923cb978fd765fc10f3d901f057bb62c52d/jc-1.20.1.tar.gz"
  sha256 "c5eb0fb0ee049cf289366f5ccfdffe2ede2cb0600db5976dc7813c93f83a3ddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e233150138b446f10088fef9c48321d2a51754bf119e7ac214506c5c2578212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddf9358468de137e30022b3d94d8a654a665e81bffbd490a008f9e0bacbda9ba"
    sha256 cellar: :any_skip_relocation, monterey:       "eeec72e9e995dd9b913dc985f56f514ad21dd273296ba0267ccf38dbfebef782"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee5cee39339274b5ff92d40b569df09474c83b97e1974cd4494922962fd286f2"
    sha256 cellar: :any_skip_relocation, catalina:       "cc286b685863dbf2a8ab490b58be17229e1b37a2295457b47374f72d76132640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ca2e71953747ade242106a497ade611ea6eca24f7f1b790fd57fdebbe0bd4f"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
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
