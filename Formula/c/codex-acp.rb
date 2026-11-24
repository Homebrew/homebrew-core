class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.10.0.tgz"
  sha256 "c2bf7bae28e4d5f096dcf7aa1a3be64dd03a594e7c5cef868d3707ee6ccf413a"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    manifest_sha256 "6dbdf339627263f209ee4cce8ec8c6841eab87123fb712979a9ded7ef4ef1070"
    sha256 cellar: :any, arm64_golden_gate: "ca0ffe952710145d62b92f3c92c2857d93ea7ec0d355e5a9136c681453212ef2"
    sha256 cellar: :any, arm64_tahoe:       "ca0ffe952710145d62b92f3c92c2857d93ea7ec0d355e5a9136c681453212ef2"
    sha256 cellar: :any, arm64_sequoia:     "ca0ffe952710145d62b92f3c92c2857d93ea7ec0d355e5a9136c681453212ef2"
    sha256 cellar: :any, arm64_linux:       "29c75929a5e135a4d369d2f4535821a5a05d4482f4dac1c4ab807c4268f9f99c"
    sha256 cellar: :any, x86_64_linux:      "7dfed1f0bcc0ad2850a833855de094d011a4d95dfd9a9760f7ac232c19a7012a"
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
