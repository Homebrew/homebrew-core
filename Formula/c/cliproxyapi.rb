class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.63.tar.gz"
  sha256 "13ef72c9d23519240e38ebe16a0a41c18147c4144ed0896852c923c4f9c22f01"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "c78ca712276b1aa895f000b14c311d75e1f4ed09309398b4158b278d64917fd2"
    sha256 arm64_tahoe:       "1613f949e2ae6a25fe9b67d54a8b4d54e109a24626ce2f1bf8522c2da2b9c0be"
    sha256 arm64_sequoia:     "108b2c64d6e3f6e5c9c76dc1388b4f8d3de2cf16ea5dd4bbb14549c0e599c0a3"
    sha256 arm64_linux:       "8bf37bd208599489c9ae709109128f3988f8a33c6a967ff9771443c3baa8b7a7"
    sha256 x86_64_linux:      "a2966970e31809b08e3075db6e0db5d71c21689ab3994c9094d5fc318c6ffa21"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
