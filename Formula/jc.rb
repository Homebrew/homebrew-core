class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/54/ad/5094b68e55408c9f0f369a28ec1e51acc77f45bf770e051a7f607a152fd5/jc-1.21.0.tar.gz"
  sha256 "f3b21c37cb5ca6da202abc24c19d472540936d3ac26a9179cf953ea4deb280bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe58cda3c0a0d60d9f17b3ee922d0322d4c5272c20511844eb3d549a2c9eccae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "092e5533dc5d3ee572ac1eed97d0e1fb55e7554d77f69739bc4f28f3c7371af1"
    sha256 cellar: :any_skip_relocation, monterey:       "a2f59fd4153a85bfc4bf0b81697f35fb5a9385d943f66b31ce04bc6da5eeda9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdbe1c6adc772bd62f583d95c4ead23f981cd712de29d5f8b173114ffee58365"
    sha256 cellar: :any_skip_relocation, catalina:       "4985c8c769454c60da7672d30f35c7df7bdf89347d972e028da170461e0efba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "777d419d516a5391d2b6ada57bc61aa392946921e223258ce79c324dd76a2e17"
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
