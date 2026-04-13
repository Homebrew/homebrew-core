class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "21b7ffed68e817df638c8e939c376e0ccd2f6f91b420730b71d3ba418c3b1205"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdb0926b605c0f8c05be807ab9a4811e2f8531a82b992726b294de10982e4f76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "430ba22fe56d6d1781ba178e8affc717034dc691f9394b6331efebf944ae5230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66884449956d2a4e3a8cf745bdadf744260cbd5d990e74e5e4421c9cf351e054"
    sha256 cellar: :any_skip_relocation, sonoma:        "088003095fbb45a9e6da4c3f60619e4f9a50d4c238d888d5833c73493cdfa67e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f34f68803bda2a3ba988a180ce8678a31edd848bf0e0d7e33404ac7a4e5aa91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "513ed77534857522d0d480f977223779e895f0d8b1c7257d27d3b16bd49b34e1"
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
