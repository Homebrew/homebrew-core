class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.6.0.tgz"
  sha256 "8d754b69e58ec0b3820039cefe0987cb059b2ef439d20415a5e875056abaebe3"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f13ade35542fa08d470d241dc125e457f6a01d7d35510f07df82666edfc49dc1"
    sha256 cellar: :any, arm64_tahoe:       "f13ade35542fa08d470d241dc125e457f6a01d7d35510f07df82666edfc49dc1"
    sha256 cellar: :any, arm64_sequoia:     "f13ade35542fa08d470d241dc125e457f6a01d7d35510f07df82666edfc49dc1"
    sha256 cellar: :any, arm64_linux:       "6b82c6da43d5a45351e30da2a60a2cce7414db2980eef5ef5ea34b002fdb1ef8"
    sha256 cellar: :any, x86_64_linux:      "5e583032390d718fe0495975b18465ce6c16e3eea5e4d192bfb131cce92f9a54"
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
