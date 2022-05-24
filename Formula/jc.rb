class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/dd/fc/1463464b90b19369d7efa2340be4adf3f6fc2b773549fcda2b940cd1d2f6/jc-1.19.0.tar.gz"
  sha256 "f4193035af79942b9c8cc57b8610da37ce8387a4fb92841643092b14e39bb679"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "650be18e01bc33b494580a5b92aab503ab4c241774f0008d887452a753a7a58d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e526c7d0d10bddb12efd1a367904fd34a4eb0fe917bf32e88052b83dc348b06e"
    sha256 cellar: :any_skip_relocation, monterey:       "d56410f853cec2c95274aeb546c6f4f92fbce9131c5d8dd0fb120bffdf9df370"
    sha256 cellar: :any_skip_relocation, big_sur:        "63fec58a1b8c66c1aee84fa5773c7b4287eb8b00e2ed63e7fa3292916e64a805"
    sha256 cellar: :any_skip_relocation, catalina:       "d333cca03ae39b2bd9fc9e10f2eaf5e87bb8bc3b916aacbe9ace393120006d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1460201ba2913c962afd4d3822a27be117febf89bd14d1981b4fe46a1921cc8d"
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
