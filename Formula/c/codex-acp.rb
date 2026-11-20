class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.8.0.tgz"
  sha256 "4c281cfc52d7ba5b2584755343bd68392d0bd92240bdf3968ea73a9a6fea5782"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b3859d558c534a43b5c8c32e2c5eae3eb8b6d7642047423bb36b5da2b8e3fbd"
    sha256 cellar: :any, arm64_tahoe:       "5b3859d558c534a43b5c8c32e2c5eae3eb8b6d7642047423bb36b5da2b8e3fbd"
    sha256 cellar: :any, arm64_sequoia:     "5b3859d558c534a43b5c8c32e2c5eae3eb8b6d7642047423bb36b5da2b8e3fbd"
    sha256 cellar: :any, arm64_linux:       "efdb515ab128ef48e9bcf4f7c7be40e927ea31232f8cb3a0c62fd7bbb4466f16"
    sha256 cellar: :any, x86_64_linux:      "54c30852d179466fc296d0f1d6938977d1fb1301f44f1b78b7c19af9bdfefeeb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    rm libexec.glob("lib/node_modules/**/codex-resources/zsh/bin/zsh") if OS.linux?
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _e, w|
      stdin.write json
      sleep 3
      output = stdout.readline
      assert_match("\"protocolVersion\":1", output)
      assert_match("\"agentInfo\":{\"name\":\"@agentclientprotocol/codex-acp\"", output)
      Process.kill("KILL", w.pid)
    end
  end
end
