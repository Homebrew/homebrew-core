class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/0e/8c/f8859a1c2f5c7de35dd020ecd66489b6570e83b609d064e9249a610036ed/jc-1.18.6.tar.gz"
  sha256 "5e164ec324182aa35571b3868e7718b163d315bea2b86b2457e554b5c0912a2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cf9e8df6a25bcc0fa5c1a3f866951eb3592125d19ae30b87dd140c671c78a53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92870616a3dbcf587baa1db7b77e421f613fcb3b39944da7bcec81ffaf6f6c8a"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc7135a7fa73caaa471220483c9f07816f9735fdaa34b9e2f176415e32085d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "54a98a4db6e483aa7d046e6d293af89ac96494e3083807d019a645c215c0aa40"
    sha256 cellar: :any_skip_relocation, catalina:       "ad5d5a60af6a6eb93e652edb43a2e00f9d4625886a837e866103b190c2b71344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76d30ec0cf369eea720128b241961d9b9ea256a0dcaf51391d38511064d448f7"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
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
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
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
