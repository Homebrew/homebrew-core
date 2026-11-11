class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.64.tar.gz"
  sha256 "2c6140435c745a0c70f67a1d2ca4d1640edcfcb6d12eb22d290e0eaad08b23dc"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "5275abab69d85513f7ffee8053348c518875f6f0146a8740a1e12cde9d4ecc00"
    sha256 arm64_tahoe:       "95bff8594e8787e5f1c72dc25efe512a994930ecf2e4af26df241b2d9520cbea"
    sha256 arm64_sequoia:     "b950e390f321de16a4f8883c7e560490b11e9c9a6276937627f1a418aac10511"
    sha256 arm64_linux:       "72d97a709425aae3c6f21611b3a999564a6198e59d19164664654ee43d0eb218"
    sha256 x86_64_linux:      "64e85e8a712048939963ddc27a5833c1f9da05cd681c1e48fbc1567c9589af19"
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
