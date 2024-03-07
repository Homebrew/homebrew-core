class CmakeLanguageServer < Formula
  include Language::Python::Virtualenv

  desc "Language Server for CMake"
  homepage "https://github.com/regen100/cmake-language-server"
  url "https://files.pythonhosted.org/packages/65/d0/caf71019da3fe2eba801c620cd2ee9a122ede9e048101bf3ee024a5065fc/cmake_language_server-0.1.9.tar.gz"
  sha256 "6b4768d89788c582b61d4503f6a3b0e594318af9d67be6d5453cded6dec0d7a8"
  license "MIT"
  head "https://github.com/regen100/cmake-language-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca40ee7fd121d594ae2fe6f7ad35fb857c3881040d587eaba1612b666eac190c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a0053ce5354dd69188749ff933ec1bff46ebfb3ed1334ca6d215edda9784ad7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ee6c9fa4d6fe748f725105583e97c8a61d84400dcee7d20ab5dc6f10461000e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c228307af2c504b2e38b7c3ce83985c2f41978d69bd61ec6cdb72e21f8cdb83f"
    sha256 cellar: :any_skip_relocation, ventura:        "a909f7776e1014441fb1d70badba3174f14e82fcbcd29a3f6915af98dc9f98e4"
    sha256 cellar: :any_skip_relocation, monterey:       "5839242de21d0ffbc482b9c5bfd72d4a806ac9d267ad053937f0ffdcbf1e70e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26ce2f5a04b2601dffcc9c5e70aabb7bb29f60870c8385131f928f5e81a78af"
  end

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
