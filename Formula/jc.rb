class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/fb/f8/38dfcd8cd2c2a49e79d9433942a81af502c590d05dd32b0107114b94fb14/jc-1.18.7.tar.gz"
  sha256 "0b1261a2c3631b67bf0b540d36ad49ee9c5648ba61fddd5f8dd953af3d7cde96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ff1b9ad43b4aed1d4d206878c0da9b90120abb34498f1852fb5bfd1e354f263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e70f612f4894e10ae91b4b5c8ad9ad28209888005ab8899336feeae98912834"
    sha256 cellar: :any_skip_relocation, monterey:       "e3f75e456a45940f52891f823f8201049c84c8b7a8857854003febc9338843a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a701f0a161fe106e5608b91345174120a7cef783670790987f89d22648c4e8c"
    sha256 cellar: :any_skip_relocation, catalina:       "62860f42adae7f5e8d0daf05e2b18ad460a73161787c1526e4e46c2a2e20200e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27049d3d903a532e9be05f9a535b50f72275c3a81fbf2836515c6adb0e699b47"
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
