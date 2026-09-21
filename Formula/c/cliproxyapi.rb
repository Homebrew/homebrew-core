class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.3.10.tar.gz"
  sha256 "f2472ce602141fee9646cfa2afabac1e52b71eceb93b6b8779e6819c80b0b24a"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "c606c6c19dbd024f1fae7a74febec75de37aba6ba9989f11729e7db09c348594"
    sha256 arm64_tahoe:       "61cba013fdde654532e88d950e6b904d6a814058a4f99a5178bafc4f53e59228"
    sha256 arm64_sequoia:     "f44d3cd8346e6939c624331c74146c6d868b6cb7e69f4cf30143050eeb5dfd5b"
    sha256 arm64_linux:       "aea320282cd7c4f0bd2cc33c4a0934c00745e9b1f3ff6728fa2b42864d0c9a0a"
    sha256 x86_64_linux:      "05a51dd62a4562c06020a09c8a50fc57dc1910ee93142558b0034b0b31cebb62"
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
