class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.55.tar.gz"
  sha256 "c5ce67432230b2ebc0f5c86ebd607b513780d90fd4c1e583c0b8d1725482ddf6"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "2da675b99c3bf5db402cb0ac3da830938935989934ffa9712ed6340ced8908f2"
    sha256 arm64_sequoia: "2da675b99c3bf5db402cb0ac3da830938935989934ffa9712ed6340ced8908f2"
    sha256 arm64_sonoma:  "2da675b99c3bf5db402cb0ac3da830938935989934ffa9712ed6340ced8908f2"
    sha256 sonoma:        "1a0f1cd4ffd9dfbf80c6a94f6c6c78f02a8211739c6c4fcf84dfc50697d3108d"
    sha256 arm64_linux:   "d31456c0793999c93c3e3b08403ae011e3cd37b0b8f56ab6d3a4ee64639b3db8"
    sha256 x86_64_linux:  "8a971587b0ae7982e509cc65213582b727d2bc78dcd99123b65c8f2a0d8ba9ba"
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
