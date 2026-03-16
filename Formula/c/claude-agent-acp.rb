class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.22.0.tgz"
  sha256 "61cfe47d72e50586c7965d4963ebeced476f6d924fa84813823493683cef202e"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6e79ac2daa1e9b008bf06ed369d9b9ed9f6c0640389ad1a5e3d73756cc5b350"
    sha256 cellar: :any,                 arm64_sequoia: "1ca044d322cd466406a50defd736fe8beadcf1cf914e14ba813d52c2fa988178"
    sha256 cellar: :any,                 arm64_sonoma:  "1ca044d322cd466406a50defd736fe8beadcf1cf914e14ba813d52c2fa988178"
    sha256 cellar: :any,                 sonoma:        "d2e7974c19b4b545e337a8f0b79139fc008c5df719de44cc24a6358a6cb60571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bf114d4feee5274a207c4c8145d51fbe01764c11097f62e78cffe4398d4370c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad93f0351aac79eb661b5d4b9b0fcac81d605db114c4a7e90954e622ef036c5"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    ripgrep_vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                         "node_modules/@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r ripgrep_vendor_dir
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
    platform_dir = ripgrep_vendor_dir/ripgrep_platform
    platform_dir.mkpath
    ln_s Formula["ripgrep"].opt_bin/"rg", platform_dir/"rg"
    bin.install_symlink libexec/"bin/claude-agent-acp"
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"claude-agent-acp") do |stdin, stdout, stderr, wait_thr|
      stdin.puts json
      stdin.flush

      output = +""
      Timeout.timeout(30) do
        until output.include?("\"protocolVersion\":1")
          ready = IO.select([stdout, stderr])
          ready[0].each do |io|
            chunk = io.readpartial(1024)
            output << chunk if io == stdout
          end
        end
      end
      assert_match "\"protocolVersion\":1", output
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
