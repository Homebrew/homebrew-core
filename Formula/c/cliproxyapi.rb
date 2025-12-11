class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.3.tar.gz"
  sha256 "bfcb09324e44b1056ce5c3201514d30602ea48441caffb2a72f1b691f78d6d51"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e46f10b53cc51d6eb64cd1d1d4c34b63087d84f8d2d23ff4cbbb945ac0e05e49"
    sha256                               arm64_sequoia: "e46f10b53cc51d6eb64cd1d1d4c34b63087d84f8d2d23ff4cbbb945ac0e05e49"
    sha256                               arm64_sonoma:  "e46f10b53cc51d6eb64cd1d1d4c34b63087d84f8d2d23ff4cbbb945ac0e05e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2e6519a78fdae1f545b40b606c521417ddabc5ae1e7c2b2668e33c05a131154"
    sha256                               arm64_linux:   "a2621d5d816a19a353ee14010deb26ddd8e6fd6ab44881a74c5dc442f2b4c562"
    sha256                               x86_64_linux:  "7cb9d468865d96c2389d8ad389f2d3f9d7a2e6f5140c780d5b872e4c69086832"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
