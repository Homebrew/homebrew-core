class CmakeLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for CMake"
  homepage "https://github.com/regen100/cmake-language-server"
  url "https://files.pythonhosted.org/packages/65/d0/caf71019da3fe2eba801c620cd2ee9a122ede9e048101bf3ee024a5065fc/cmake_language_server-0.1.9.tar.gz"
  sha256 "6b4768d89788c582b61d4503f6a3b0e594318af9d67be6d5453cded6dec0d7a8"
  license "MIT"
  head "https://github.com/regen100/cmake-language-server.git", branch: "master"

  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/1e/57/c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284/cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/9d/f6/6e80484ec078d0b50699ceb1833597b792a6c695f90c645fbaf54b947e6f/lsprotocol-2023.0.1.tar.gz"
    sha256 "cc5c15130d2403c18b734304339e51242d3018a05c4f7d0f198ad6e0cd21861d"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/e9/8d/31b50ac0879464049d744a1ddf00dc6474433eb55d40fa0c8e8510591ad2/pygls-1.3.0.tar.gz"
    sha256 "1b44ace89c9382437a717534f490eadc6fda7c0c6c16ac1eaaf5568e345e4fb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/cmake-language-server", input)

    assert_match(/^Content-Length: \d+/i, output)

    assert_match version.to_s, shell_output("#{bin}/cmake-language-server --version")
  end
end
