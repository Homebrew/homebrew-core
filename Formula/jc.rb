class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/29/00/7f9a80718dae39f2909261b89e8c2d491a6801d8d2dddd2ab74e07f94b16/jc-1.21.2.tar.gz"
  sha256 "1e64d28bae3061dc66042accc99a637069aa91848300c7e01a0ca992e5b661cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb90c0fb2f87f245899520c1a5e42e7265a130ed07667db6785ba3960717490"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df038d3043a44cbfaf0bb2833cfea207be2e20b3450dc8cca98bf8761a45cec2"
    sha256 cellar: :any_skip_relocation, monterey:       "d9042618ec99f1274fa08212b20052816bc8a20a8e178b9bde2f429ea922c9f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "409d8d2388212d9a18f5cf71f55167567fc4a747572039b21d7f2828b8440727"
    sha256 cellar: :any_skip_relocation, catalina:       "92ded82abc7624d744f3ddbf1e3b56792168c0baa3cd4e801de4584eae4f1902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6d13c0b6b3a6f55073c72a17dc1f68df4fa350a763e329d1c62bfabdc58ddc"
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
