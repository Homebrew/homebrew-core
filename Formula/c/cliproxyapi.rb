class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.80.tar.gz"
  sha256 "7d6d050e857ba3ea9e9b2daa24adbfb401d8b67758e047d7fecb611c9735d637"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "4fc729109b089d2ce782e3c5f3a8cba04b39b12984bed7bf96ccbc5a3f537457"
    sha256 arm64_tahoe:       "084dd2d793cee9f483175a4bda36d61f520d5aad1b47a84c9e3912ab39785951"
    sha256 arm64_sequoia:     "8043fa0de0dc1aa1a184ec0554b05a424e93ea2fa04dd820c36d522cf3a355b2"
    sha256 arm64_linux:       "f69bd0d5ff65a067319c458c9a027797a6bf7e34a4bc1c31c9a91927582dc79c"
    sha256 x86_64_linux:      "c7f39bbd886ff97cddf5360636bf438001004b57f5f4de43c9516898074a44d3"
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
      -X main.DefaultConfigPath=#{etc}/cliproxyapi.conf
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
