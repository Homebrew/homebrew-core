class CodexAcp < Formula
  desc "Use Codex from ACP-compatible clients such as Zed!"
  homepage "https://github.com/zed-industries/codex-acp"
  url "https://github.com/zed-industries/codex-acp/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "8b47a531183f79dbdbdf1700df458c9274f2e342a3d4b0964840fe7972800c9b"
  license "Apache-2.0"
  head "https://github.com/zed-industries/codex-acp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8235f5fe3fa4f725f2eebee9ba321aa6aae02713ce81d60c784ba5dd58d662fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87f62c521cdfd360300da8854a235bbeba68e63a91cd5d372429369d557d2449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b0e419d16994ac72094b801dab806e5097e45b59110d6694e9081eac7606c71"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1d19ccaee6d172d14fb86d562a079e8bb2acf862ff57c7ae55baf4cffdf627"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8125c9c0bae3191d4fb8f8f83867b978be21878d37aae3ff16300ae7996c6964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1843bec2225452cae9ee14cf913bd6563fb3dbc60b3aa6e9250ddca5bbbb6524"
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
