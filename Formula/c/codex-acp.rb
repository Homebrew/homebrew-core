class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "ee715faa4ebfefaee87ecdd4b06238d35693823cb7b907b08e0f7e39e7fc0f22"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c9ca460e3fd430e3a840b43259e1ea740334c9ac299672fff463328b4ecf256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "049359709da792fa573774b13701fa0c718d72106d22a3b14304bc4125e9526f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde60b78cfc5fff3bcc24d4ce803d70defa482ad536766430242f92aa8b05356"
    sha256 cellar: :any_skip_relocation, sonoma:        "b095d25e91a51dd16d7ed839dfe16740ba647017879e74ec819a590c01c63911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6f59333ee1e351ff4d8b97d99bda78dd8f89172aceacb3b76680e67014b8057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "326f6416415b339b1e238b518a5de7219b64156db728130af8e0b81541e26b16"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"
    require "timeout"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1}}
    JSON

    Open3.popen3(bin/"codex-acp") do |stdin, stdout, _stderr, wait_thr|
      stdin.write(json)
      stdin.close

      line = Timeout.timeout(5) { stdout.gets }
      assert_match "\"protocolVersion\":1", line
    ensure
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
