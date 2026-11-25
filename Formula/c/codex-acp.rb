class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.12.0.tgz"
  sha256 "2c6be361e2c1f313cb1391a9b38f64338addfe58b99f3e620fa85521112770af"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    manifest_sha256 "503bd5c81b50de98ebd89328873970121b8b8efdb0443eae5bb221d232b2ab16"
    sha256 cellar: :any, arm64_golden_gate: "58ba3b755b787c6384d43c3768f30db31611a79fd80e784d5a05a27c7ff4dfcd"
    sha256 cellar: :any, arm64_tahoe:       "58ba3b755b787c6384d43c3768f30db31611a79fd80e784d5a05a27c7ff4dfcd"
    sha256 cellar: :any, arm64_sequoia:     "58ba3b755b787c6384d43c3768f30db31611a79fd80e784d5a05a27c7ff4dfcd"
    sha256 cellar: :any, arm64_linux:       "6cccb37e2d0d9309a2161e1b8f25b6e7266c258000712a86149fa5447b45d737"
    sha256 cellar: :any, x86_64_linux:      "89ecca18435480498cca5c185619cdbbb3efcce52fbd33197c6280a418311b8f"
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
