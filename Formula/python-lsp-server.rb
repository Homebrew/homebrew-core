class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/f9/1a/4c8a34472a18df991c75004586625ac1cd145a164dd8e69c1c1a625e09c2/python-lsp-server-1.7.2.tar.gz"
  sha256 "b2433467d0fcb8fd45828463ff1cc805837c08731fcea5d7d953d9be776881e1"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d5a952976ada23914e8af96d2f4686e2d987fa048cfa6dcde6ffb8191c109d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f198f4dfcdd7f683d329bb82cf1391595fc8d0c8b4ef0765df200084ad91e9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8ef26143302507619ddc4203c5945924fcda63031537ef1dc23092c563db8f6"
    sha256 cellar: :any_skip_relocation, ventura:        "55ae3463491a366616fdfb3b4485a288b2f656123df82c4d6146ce21102fe4e5"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f46b9ff1f9e0fb6b1446055734ee7caea08d19c85b452f55e327c9579a67cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa8c335b33b28e17ac368026017f309768100ceea4d22fc549a2c7bc42169e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acd99dbef53162bd063162208ef0d2af8119818198f6d4913ed2d9b3ff710d5"
  end

  depends_on "python@3.11"

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/c2/6f73c08b97bacd1242835bdca1cfc123b059eb15af9350eb1eb5d58868fc/docstring-to-markdown-0.12.tar.gz"
    sha256 "40004224b412bd6f64c0f3b85bb357a41341afd66c4b4896709efa56827fb2bb"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
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
    url "https://files.pythonhosted.org/packages/43/1a/b0a027144aa5c8f4ea654f4afdd634578b450807bb70b9f8bad00d6f6d3c/ujson-5.7.0.tar.gz"
    sha256 "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23"
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
