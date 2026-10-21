class Esbonio < Formula
  include Language::Python::Virtualenv

  desc "Language server for working with Sphinx projects"
  homepage "https://github.com/swyddfa/esbonio"
  url "https://files.pythonhosted.org/packages/68/e6/b40e53f2efc28fc18319795800cd3cc1dca6215cf34b55d0183361adebff/esbonio-2.1.0.tar.gz"
  sha256 "7fd6973616c88689800ff3de17ce929c6dfe34fedf6e2c142e2b7ceab8b2ebbd"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "278831a9f7ef18b32165461987eb4293d9ae26e6933c152e976774a4314506e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4de7dff017cf56b5463b1fa7a2ab744eea8c9e45df515dd74fcb738c5eae903f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "183da30c35fba7960d5aae46e549fa85ddf5578223d1667b830293982f388fb6"
    sha256 cellar: :any,                 arm64_linux:       "dbaa8ed7b88b739f3fb1ffb9ba55d113364b7b77e56bcbb96233c699b8a6f148"
    sha256 cellar: :any,                 x86_64_linux:      "94fe365da023c42d0882f9026f48ec00e3f0b84ab92824a652f1499a1e88fab8"
  end

  depends_on "python@3.15"

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/23/75/e72b839c3dc869c990b4842f3dba730bdcdf5215f68fc7955edf849a1792/cattrs-26.2.1.tar.gz"
    sha256 "679132bfdc225c5ee40c024fc42519954767c387f950dc6751946c586bccdc6d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "lsprotocol" do
    url "https://files.pythonhosted.org/packages/e9/26/67b84e6ec1402f0e6764ef3d2a0aaf9a79522cc1d37738f4e5bb0b21521a/lsprotocol-2025.0.0.tar.gz"
    sha256 "e879da2b9301e82cfc3e60d805630487ac2f7ab17492f4f5ba5aaba94fe56c29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/90/a1/d5f9002a70298c64a789779077d8dd90c10aa1f47fe40c86802df874f2a6/platformdirs-4.12.4.tar.gz"
    sha256 "63743c02414e755de4e31b8f68125c1407495b86c5a006e203c01ff8b9924250"
  end

  resource "pygls" do
    url "https://files.pythonhosted.org/packages/da/2e/7bbe061d175c0baddde8fc9edb908a4c31ba5d9165b8c68e3439c3a9f138/pygls-2.1.1.tar.gz"
    sha256 "1da03ba9053201bb337dcdd8d121df70feb2a91e1a0dcc74de5da79755b1a201"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/01/89/3f825ab71c242fffb62ea8fe638741c290f62f8d7aadf8125ff897747af3/websockets-17.2.tar.gz"
    sha256 "36c2fb94c990cc2545143b12690e2de6c16300f9dbe5b4f33fa300cf57dc8792"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/esbonio --version")

    require "open3"

    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { rootUri: nil, capabilities: {} },
    }.to_json

    Open3.popen3(bin/"esbonio", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
