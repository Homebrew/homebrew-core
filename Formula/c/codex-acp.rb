class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "af421ff96336f85af1ef46ccbcbda7b498a161883f5c46e3371131b887dea599"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f17fb8d09f816fcfd9f3002aecc3a998f66aff81fcff9c81e1ec52765d99dfa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d62da250103babc3aba1960c5515cb4947e423c4d4c3f9e2e6acf79b4c5de6a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e0ae2aa24f406d7737f9b8f291fb2012e19293f5b155833342bcdd02854e2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cba371605872cc302c595df7c09b18d1c56c115335962d9a6c63b1e400de841"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1686c465f63cb8b2fe1929fbf679045bd96d1262aeb1248709518edf38d7865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be63f864294db817effb24c47dbf526809bc2ac90b55b824828b568d48928eca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "libcap"
    depends_on "zlib-ng-compat"
  end

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

      line = Timeout.timeout(15) { stdout.gets }
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
