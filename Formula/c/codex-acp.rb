class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.12.0.tgz"
  sha256 "88be88abaa67293e0c3fae21128249911a5e01640dec6319030b06b6b4f660d1"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6746d5c4d8bf34cfa61064bcf02153d996f994c997c87385f139035c513a7340"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6746d5c4d8bf34cfa61064bcf02153d996f994c997c87385f139035c513a7340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6746d5c4d8bf34cfa61064bcf02153d996f994c997c87385f139035c513a7340"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8976395f52fb479b618ba9960b6c40240f680a08badd1100579649a28fac012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "84249e4bc1003f665f8a2452ac38a0ba4eeb59d8b04dd6c105a84f2733dd4e23"
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
