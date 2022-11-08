class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/13/c3/02952e2465da01d2b9f3df8972ddce72fe4ac471fa9af9fcc7a89dc8f863/python-lsp-server-1.6.0.tar.gz"
  sha256 "d75cdff9027c4212e5b9e861e9a0219219c8e2c69508d9f24949951dabd0dc1b"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e80e963fe17745bfcb9a975b173283537c0be0dae2c64803e862a062a66fe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0be623c09688e712b095a5dd48d2785f6fdde27f1dbb4268226233033ff3608a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4db452c719d04afd093cb64f776bef0fd76987422b4111554e31c3fc1ec92238"
    sha256 cellar: :any_skip_relocation, monterey:       "8b63d3caac9372e49cae574a289222ab4919669bc09ae83e8bb4a98cd1e17b13"
    sha256 cellar: :any_skip_relocation, big_sur:        "28d28aace6138499d16809656bb282f2e467ca0f2aaa561de542f2ee4bb1f065"
    sha256 cellar: :any_skip_relocation, catalina:       "98e208b76802d77b63a9a2aa5e9c5883f639d45be559c4f4880a36a052c70add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ba66f2c44bd11458288f3b7aed801e4395ea05b005b670cb5e23de304437da"
  end

  depends_on "python@3.11"

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/1e/c5/53e13bb0e3dd8b7fa3595c80deb40a3742dd191a9350141d4daa7ab09a9f/docstring-to-markdown-0.10.tar.gz"
    sha256 "12f75b0c7b7572defea2d9e24b57ef7ac38c3e26e91c0e5547cfc02b1c168bf6"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/6e/4a/03ddad85a10dd52e209993a14afa0cb0dc5c348e4647329f1c53856ad9e6/ujson-5.5.0.tar.gz"
    sha256 "b25077a971c7da47bd6846a912a747f6963776d90720c88603b1b55d81790780"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
