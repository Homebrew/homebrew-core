class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.3.15.tar.gz"
  sha256 "5a6fc5058ca443d046e01b92e730707838975d56e34ef995cca85b01435d6e60"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5, days: 2
  end

  bottle do
    sha256 arm64_golden_gate: "ddd9faa5f34ad15807fdc7bcc7d7d61f2770c3a656a0c6f66cd1018c3b87318a"
    sha256 arm64_tahoe:       "5403c506bb02371ec0f95fafc06371830475f6d721b39ce5197e8f03d71b1ac0"
    sha256 arm64_sequoia:     "93b949f4e5aa4585c9b58acbf0857df38ad165ae127c8e019a1f930e6f6166cc"
    sha256 arm64_linux:       "695d11722a5966a5756d60c9500ce1026d9906ec135b8ed331abdb5e72100eb0"
    sha256 x86_64_linux:      "45711b9947591dcdb380f003a9e7198283ba15f341335eb3f53167118af59739"
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
