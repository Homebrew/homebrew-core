class CodexAcp < Formula
  desc "ACP server that exposes Codex CLI functionality for ACP-compatible clients"
  homepage "https://github.com/agentclientprotocol/codex-acp"
  url "https://registry.npmjs.org/@agentclientprotocol/codex-acp/-/codex-acp-1.6.2.tgz"
  sha256 "03449fd0d37739203821edb6f6fbb845a8e6a20f7da294cedd4a6cc7121219d6"
  license "Apache-2.0"
  head "https://github.com/agentclientprotocol/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca1a12c975dfac0b7038a1da10807b83686e15318e6c493f1d06d7440d823681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca1a12c975dfac0b7038a1da10807b83686e15318e6c493f1d06d7440d823681"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca1a12c975dfac0b7038a1da10807b83686e15318e6c493f1d06d7440d823681"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dab632cd6e29e782ce86084da8269c7538d293773e1e1adf629ed1fba669731"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99a3ecf9da6141d578f042b96643f90d063795856c8e98ab77face7d2c966984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "319ca3be57bf9a9abc96b818459482bf95c70797da069fad0b12d159751c1a23"
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
