class ClaudeCodeAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-code-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-code-acp/-/claude-code-acp-0.13.1.tgz"
  sha256 "a8a6596cd3b15a367f81c95806c6626453ef07bd2eb89d692c919cad9ac1f021"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-code-acp.git", branch: "main"

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_path = libexec/"lib/node_modules/@zed-industries/claude-code-acp" /
                   "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_path
    (bin/"claude-code-acp").write_env_script libexec/"bin/claude-code-acp",
                                              USE_BUILTIN_RIPGREP: "1"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-code-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.flush

      line = Timeout.timeout(5) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
      stdin.close unless stdin.closed?
      if wait_thr&.alive?
        begin
          Process.kill("TERM", wait_thr.pid)
        rescue Errno::ESRCH
          # Process already exited between alive? check and kill.
        end
      end
    end
  end
end
