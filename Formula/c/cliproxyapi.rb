class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.35.tar.gz"
  sha256 "1373a619b05c63ef8cb3e7c50469cfaff75a72a687229c4e4e929d3046e2cb4c"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "fcf5db64a4744e45c741b9f1f977907be238672c58781a817e16c0494050ce1f"
    sha256 arm64_sequoia: "fcf5db64a4744e45c741b9f1f977907be238672c58781a817e16c0494050ce1f"
    sha256 arm64_sonoma:  "fcf5db64a4744e45c741b9f1f977907be238672c58781a817e16c0494050ce1f"
    sha256 sonoma:        "d5b95ea4c6544bbb45d23da9b748def63323db867753640e04c96c2478e9fabb"
    sha256 arm64_linux:   "d3687e2abaa4e70fa73a890bfb91857d47755f3d8c889529aba580cb76eb3499"
    sha256 x86_64_linux:  "ea898393c72f66288e3a1259bd0b30bfa3f973ea0ad21782c60790b8c2335638"
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
