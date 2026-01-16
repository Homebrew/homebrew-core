class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.0.tar.gz"
  sha256 "dc9cb25a1f5e9664ded7cfd65b973bf94120b186bb45d2b6f27c83ac3448495f"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "10171b88c3e10d0b6cbc8a82117f9d26b25064dc5b0b16d8982f601f61e0fddf"
    sha256                               arm64_sequoia: "10171b88c3e10d0b6cbc8a82117f9d26b25064dc5b0b16d8982f601f61e0fddf"
    sha256                               arm64_sonoma:  "10171b88c3e10d0b6cbc8a82117f9d26b25064dc5b0b16d8982f601f61e0fddf"
    sha256 cellar: :any_skip_relocation, sonoma:        "12fd416d0b30db9d3e4858e469a6f7f398b5f60f9c42f38728f9800332b0af6e"
    sha256                               arm64_linux:   "28bdd98e09a8076671fa64c261e3f51bb589c9500316e07c62a13888471fbb63"
    sha256                               x86_64_linux:  "3f5c91e987621c23bcd2348940be3a487f37484ae0ace017daba4c3586a57887"
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
