class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.12.1.tgz"
  sha256 "eb0823ed12856193624dd1aeaf293f4fe63d4d44ef82666a35a4567923986cce"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    manifest_sha256 "ab9b142238f337fa1ad90a69333f89ec597042eaa443220ebb53b8feda20ccce"
    sha256 cellar: :any, arm64_golden_gate: "2078f8af086ec57c77b8b521bca84083b7e062bb90e155be7ddb3d47142d1103"
    sha256 cellar: :any, arm64_tahoe:       "2078f8af086ec57c77b8b521bca84083b7e062bb90e155be7ddb3d47142d1103"
    sha256 cellar: :any, arm64_sequoia:     "2078f8af086ec57c77b8b521bca84083b7e062bb90e155be7ddb3d47142d1103"
    sha256 cellar: :any, arm64_linux:       "efe5f777fcc86083c19c1fd3ec2ac65a7ea07230e7911a2a1407a17d4e978e77"
    sha256 cellar: :any, x86_64_linux:      "b018fbff6e2d69bc1712e91c7d3d9304605e8bff49b9ad69cda435ad6580561e"
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
