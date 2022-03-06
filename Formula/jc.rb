class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/19/0b/3366fe67686600ad29f080f63080186b2794fcc650b5c7a2c4fbf324cd38/jc-1.18.5.tar.gz"
  sha256 "3b337b8b59f3de712638f0063133a95c31bf799944a223d7b6df877a082805a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "450af22d4023531933ae576a13b4b3a4ff1c222df57c4006b54b7828225dcfe5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef1f19fcfc63444b5452d11cb5d3bf328dc2fb0cb5db2d9a5bdef2ee0dc6da7c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd20ce7eb88263064ac7875a8f02c3052bc46560813c40f750542957c5ab73de"
    sha256 cellar: :any_skip_relocation, big_sur:        "015f512b9e95b9fbb5bbccfe2488e0c3589247dca35d3faccd2fb1454862671c"
    sha256 cellar: :any_skip_relocation, catalina:       "5a1a9d5a73dcbf89629cb13b901c45a58d926a37d9741e4432ed03b2c07b432b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053895161eb75f8d1529c229109dd6fd923777a6a8934ea0dbd13cdd4468dc57"
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
