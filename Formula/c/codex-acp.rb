class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.9.0.tgz"
  sha256 "8fce3bb06be5c1e18fdc947dddda4e87458e5f088c00087c9ebad1ea979f9f1f"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    manifest_sha256 "a68d7ee63852fafc8121218e546a1b11a71c3f4bfcc8ee8792c3c1716bf729db"
    sha256 cellar: :any, arm64_golden_gate: "ee7abcc92a6ff815772c2d55ddcdd4f29cb706b59a5520bf9e27a13b4c3e3077"
    sha256 cellar: :any, arm64_tahoe:       "ee7abcc92a6ff815772c2d55ddcdd4f29cb706b59a5520bf9e27a13b4c3e3077"
    sha256 cellar: :any, arm64_sequoia:     "ee7abcc92a6ff815772c2d55ddcdd4f29cb706b59a5520bf9e27a13b4c3e3077"
    sha256 cellar: :any, arm64_linux:       "e44e6c05490bf8e0bf3728caa8ed319797b29a94400ab5e523fed3a376cf15a6"
    sha256 cellar: :any, x86_64_linux:      "9d77e36d7edb56d27a5598bbe1accccba4ab0afa431f30fcb07dc5e7053cc094"
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
