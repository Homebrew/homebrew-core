class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/dc/b6/97e3c3e4b61290452d6967f36923cb978fd765fc10f3d901f057bb62c52d/jc-1.20.1.tar.gz"
  sha256 "c5eb0fb0ee049cf289366f5ccfdffe2ede2cb0600db5976dc7813c93f83a3ddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b9bbf492d9b7d65141cad437b332e54734fabb3c3e38b08bd8a35262207998c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a33fbdbd879343a1e38e151f2c028f08ab60ccbbc549f3bf3b13ed416b430050"
    sha256 cellar: :any_skip_relocation, monterey:       "18d5592a46c6ff24ed7948da1f57634dbefb409ae07af9b868c82b2a9d8328b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c585173dee832374f6c900bb0d859c2a7010de11c0ed2afe076ada4fe3734044"
    sha256 cellar: :any_skip_relocation, catalina:       "8d3575bf5a61d82266151c1634d417cf108253a92cf297b83914fb48b207eb4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51493abb438e9e1894723ea0344d88a5d761b9cd350d4edcba26b3cf3fb8cdaa"
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
