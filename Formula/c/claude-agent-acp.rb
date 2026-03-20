class ClaudeAgentAcp < Formula
  desc "Use Claude Code from any ACP client such as Zed!"
  homepage "https://github.com/zed-industries/claude-agent-acp"
  url "https://registry.npmjs.org/@zed-industries/claude-agent-acp/-/claude-agent-acp-0.22.2.tgz"
  sha256 "780ff4aa3dac8f120abeec1f3b3a575a56c25b9647441c52090bf0b1f3a265ea"
  license "Apache-2.0"
  head "https://github.com/zed-industries/claude-agent-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b5d9ac58b0fdd320b8c456cd524fb542c6d147c044524bd3f175c0043f5ef763"
    sha256 cellar: :any,                 arm64_sequoia: "ff272f71584b1196ff9281413fc87f9b8265428c6bcaf9e1e995541803ca3977"
    sha256 cellar: :any,                 arm64_sonoma:  "ff272f71584b1196ff9281413fc87f9b8265428c6bcaf9e1e995541803ca3977"
    sha256 cellar: :any,                 sonoma:        "657a85e86670e50fad469a6a25288a1f96a0293a725682a98e09222754d483ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "082aef932ba0272c43f86ae63666d9fc31205f2d8d78648058238e0b067144b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7daeea9fbc07c672f6660ce41cdf908dadd55e71bfdaa7512f4f881e4718adfc"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    vendor_dir = libexec/"lib/node_modules/@zed-industries/claude-agent-acp" /
                 "node_modules/@anthropic-ai/claude-agent-sdk/vendor"

    %w[ripgrep audio-capture tree-sitter-bash].each do |dep|
      dep_dir = vendor_dir/dep
      rm_r dep_dir
    end

    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    ripgrep_platform = "#{arch}-#{OS.kernel_name.downcase}"
    ripgrep_vendor_dir = vendor_dir/"ripgrep"
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
