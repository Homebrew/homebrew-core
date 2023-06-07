class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/73/82/34eea2e9f8b93f2cb97425140e06cae21a1e43a93ee3da70c975856c9281/python-lsp-server-1.7.3.tar.gz"
  sha256 "a31b0525be6ec831c7d2b476b744e5aa5074633e1d1b77ee97f332cde15983ea"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47e80469a08de2808310820ccbaaf46918c719ddb381a4460c09f4e941559b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b8f30603c0449a32d1eb02f0a34f17e7f8fcf4d78e4837b063e5b78b502ecb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "158999e728ab69a8bbf0be3ea9c48d6ad4172f4b1297ea2d1ac041aa248514e1"
    sha256 cellar: :any_skip_relocation, ventura:        "884bfd971d9c4b016ca05b375b8ca9b86ea929bbd8a850e58669f63cfdd3a0b5"
    sha256 cellar: :any_skip_relocation, monterey:       "27dcec30cb549f3f3855f428578bd779a49b1c849dbc2a30c5b071c8f3bf87ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "35664fb796ec8998c93f8590b2b54eb326c89cf01fad81e177d72bd6af03b3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70ef0de7ee3edd03a8d8ca0e1ca3000fa3e6ec9597b0e514c2c09b8a19069f4"
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
