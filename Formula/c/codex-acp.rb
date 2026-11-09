class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.6.0.tgz"
  sha256 "8d754b69e58ec0b3820039cefe0987cb059b2ef439d20415a5e875056abaebe3"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a6b760cdfe337c4420c6bc00f43757678d839bf66bc3e984129153295f3c2773"
    sha256 cellar: :any, arm64_tahoe:       "a6b760cdfe337c4420c6bc00f43757678d839bf66bc3e984129153295f3c2773"
    sha256 cellar: :any, arm64_sequoia:     "a6b760cdfe337c4420c6bc00f43757678d839bf66bc3e984129153295f3c2773"
    sha256 cellar: :any, arm64_linux:       "4c6820e6792ad7b07fc35717060f410f2b2628f0ada03a047b944160477bf5bd"
    sha256 cellar: :any, x86_64_linux:      "8bc778fb9c86bcc2a68b0309ba9d44c4f0271f9fe532aba614b67d4e61509cd0"
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
