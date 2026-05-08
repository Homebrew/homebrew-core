class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "7a8b8adf63969b33650988e70fa5802750fcf30155be11d5de8c53d35bbc79b2"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b85ab0bf5fe916f9d5ceea444d10235c0108588c726caa9288c3bd259f5cd149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d05389d61a2583032550832e2e8a1ffc73b8ea27e8d0c7111879302fd5303c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3843b077a1fa507b5d3fa5a2477981d3bf7939afe039fd0d91c8aa5a836206eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e6de1895af220999222627ab9c82fb21f21d32f249e7ecb0b934e590dc98c51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "603195a8601146ebe3782d381bea524f97ac95eabd005735c3829a0b7d02525c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b6a0f9d7bc02aa7c42d10c1f727e09e8b7fa8f3daf306ac6207851a49d1ca72"
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
