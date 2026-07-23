class Esbonio < Formula
  include Language::Python::Virtualenv

  desc "Language server for working with Sphinx projects"
  homepage "https://github.com/swyddfa/esbonio"
  url "https://files.pythonhosted.org/packages/68/e6/b40e53f2efc28fc18319795800cd3cc1dca6215cf34b55d0183361adebff/esbonio-2.1.0.tar.gz"
  sha256 "7fd6973616c88689800ff3de17ce929c6dfe34fedf6e2c142e2b7ceab8b2ebbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "100f216f03616b6d222161de1747fe482e333a03cce6347f760987f874e968f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a92b25eb73c0fcffeaf6d846b0d6229a905b984eef64d2fafa4905d9acc34a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4b1ecc42f9c797121c766925a898124301d621458a95be40ff055669df9a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c28e149b9a979df21b4ddb165a0dfd1e3825c037f62dc9769ba8e7ef1c791322"
    sha256 cellar: :any,                 arm64_linux:   "702e6519514e1c7289a4cf9539bab2f03b5497917a7705883ed4504ec48a3bd6"
    sha256 cellar: :any,                 x86_64_linux:  "8b0f7b22a8e5927f592fa911ed130c368942d312582960b48be53d455c938574"
  end

  depends_on "python@3.14"

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "cattrs" do
    url "https://files.pythonhosted.org/packages/a0/ec/ba18945e7d6e55a58364d9fb2e46049c1c2998b3d805f19b703f14e81057/cattrs-26.1.0.tar.gz"
    sha256 "fa239e0f0ec0715ba34852ce813986dfed1e12117e209b816ab87401271cdd40"
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
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
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
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
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
