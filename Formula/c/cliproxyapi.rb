class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.15.tar.gz"
  sha256 "334fbb378dfc8fb18b217ffb65a9bb0608356b2327b916333ed4e3f69b1326c0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5, days: 2
  end

  bottle do
    sha256 arm64_golden_gate: "f6c405ace2e8d6928c4c76f40d4af054d503c12c3ecb2b0b7112a1b4e2c4ae01"
    sha256 arm64_tahoe:       "75477f4e5d533e9f17e348291814d2ff571b77d236b18b9d7aa197b777cc694d"
    sha256 arm64_sequoia:     "36c656f278503ed7d70157c2a209c1ec3298c8f1202b6ae79f7282d9fd659f95"
    sha256 arm64_linux:       "db617d55e5d4d04ee6857da5f411b92caa5ebb64fff91f51ab2920622993fd7b"
    sha256 x86_64_linux:      "ce7de7ff0333f41480a99a4d217da61299c17616832a20a9dc0feb166939bda4"
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
