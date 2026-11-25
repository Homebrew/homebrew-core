class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-2.12.0.tgz"
  sha256 "2c6be361e2c1f313cb1391a9b38f64338addfe58b99f3e620fa85521112770af"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    manifest_sha256 "119b8ce35b2361d2a154c67dcd2a52255e76972e89ab57b479e433ad93b96748"
    sha256 cellar: :any, arm64_golden_gate: "7a482333b514e492a2f334363faffbff9aeb5d50a47d40f4ae28f8d37e109edd"
    sha256 cellar: :any, arm64_tahoe:       "7a482333b514e492a2f334363faffbff9aeb5d50a47d40f4ae28f8d37e109edd"
    sha256 cellar: :any, arm64_sequoia:     "7a482333b514e492a2f334363faffbff9aeb5d50a47d40f4ae28f8d37e109edd"
    sha256 cellar: :any, arm64_linux:       "021dda2d99ce2c99ec5fdd47535a963844f6e8ba100f92369fb78d49a32f49ca"
    sha256 cellar: :any, x86_64_linux:      "c16418ff6064f8ef90a0546b4c18a852bd33fbfb757179d3200ac14f90967299"
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
