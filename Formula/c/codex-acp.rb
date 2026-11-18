class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.7.0.tgz"
  sha256 "014bb39447296fe77b0548d8b897bcb8b1a02033e69d27389e93bacb110e774f"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "06598f22b6a74d5b9c110d36aedac99652a0e92b8be0e06d4b2f9aa155846309"
    sha256 cellar: :any, arm64_tahoe:       "06598f22b6a74d5b9c110d36aedac99652a0e92b8be0e06d4b2f9aa155846309"
    sha256 cellar: :any, arm64_sequoia:     "06598f22b6a74d5b9c110d36aedac99652a0e92b8be0e06d4b2f9aa155846309"
    sha256 cellar: :any, arm64_linux:       "431742615e2733555608b47811b4b7a53a0174c04d03bfa00e6797e16d538930"
    sha256 cellar: :any, x86_64_linux:      "fa25a121e01263bc7ce914e5ab0e6c91fa3aa88c710735d2a688ddd34a035e16"
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
