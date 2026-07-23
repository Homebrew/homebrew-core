class CmakeLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for CMake"
  homepage "https://github.com/regen100/cmake-language-server"
  url "https://files.pythonhosted.org/packages/cf/ad/54c337fd2093a7c7c13528ac1393aeda009cdc16be954041834328845237/cmake_language_server-0.1.11.tar.gz"
  sha256 "005f48367ec569457a7229a58f6762044fddacac647858b39d725ae2b3cd695b"
  license "MIT"
  head "https://github.com/regen100/cmake-language-server.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "4067002616d19dd610a111948026e3ef733dbffb44c86238cf882fe3b2b26359"
  end

  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/49/7c/fdf464bcc51d23881d110abd74b512a42b3d5d376a55a831b44c603ae17f/attrs-25.1.0.tar.gz"
    sha256 "1c97078a80c814273a76b2a298a932eb681c87415c11dee0a6921de7f1b02c3e"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/64/65/af6d57da2cb32c076319b7489ae0958f746949d407109e3ccf4d115f147c/cattrs-24.1.2.tar.gz"
    sha256 "8028cfe1ff5382df59dd36474a86e02d817b06eaf8af84555441bac915d2ef85"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/86/b9/41d173dad9eaa9db9c785a85671fc3d68961f08d67706dc2e79011e10b5c/pygls-1.3.1.tar.gz"
    sha256 "140edceefa0da0e9b3c533547c892a42a7d2fd9217ae848c330c53d266a55018"
  end

  def install
    # Unpin python for 3.14: https://github.com/regen100/cmake-language-server/pull/104
    inreplace "pyproject.toml", 'requires-python = ">=3.8.0,<3.14"', 'requires-python = ">=3.8.0"'
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmake-language-server --version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output(bin/"cmake-language-server", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
