class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/12/ae/91ea500b328248d5fed7b5e535eadbc54e01d8bcf0e398c9415d263d1dda/jc-1.17.6.tar.gz"
  sha256 "581b4a18174adfe6a2aadf681f716adfcc6fb99454cd8410126a1c6ab9a33f16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c25ce7b95d98b5972eccc18e3fe3a642db5bfe75a047ca857cdc6d23a9d95ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c25ce7b95d98b5972eccc18e3fe3a642db5bfe75a047ca857cdc6d23a9d95ec"
    sha256 cellar: :any_skip_relocation, monterey:       "c6fd6cf9d803a67d04c0f2469caa8bac0f65b2f21126ef0eb6b2f6a646d6ce20"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6fd6cf9d803a67d04c0f2469caa8bac0f65b2f21126ef0eb6b2f6a646d6ce20"
    sha256 cellar: :any_skip_relocation, catalina:       "c6fd6cf9d803a67d04c0f2469caa8bac0f65b2f21126ef0eb6b2f6a646d6ce20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a09513d7ad84258937741c8d6891cd15854b2650ad2293cdbca1c33a71693c4"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/53/5345177cafa79a49e02c27102019a01ef1682ab170d2138deca47a4c8924/Pygments-2.11.1.tar.gz"
    sha256 "59b895e326f0fb0d733fd28c6839bd18ad0687ba20efc26d4277fd1d30b971f4"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/2d/b1/b672cbe8be9ea09d85d2be8c3693811362295aa8483849e85b41caaadb85/ruamel.yaml-0.17.20.tar.gz"
    sha256 "4b8a33c1efb2b443a93fcaafcfa4d2e445f8e8c29c528d9f5cdafb7cc9e4004c"
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
