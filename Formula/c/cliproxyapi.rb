class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.58.tar.gz"
  sha256 "01e9fbecad0222057a31cfb2d325f80d0b378e8e256a4612311f48f63d1762b0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "641e7228ae418d5aed000bdc525860d756bb98d866c3a98e72d91a849f26a2cd"
    sha256 arm64_tahoe:       "3be4cc129912f9d4765c0c6f5f3a52487ec3cd8accf4c1da9dd2f5899c326bf6"
    sha256 arm64_sequoia:     "d81d3f31630c00cb71e236acef4983ae13a199cb651395d407b0fc5e7f5e78fc"
    sha256 arm64_linux:       "a1926e40f253c93b8414eb73dedc91e61798f37109e216d17c515725f21a47ba"
    sha256 x86_64_linux:      "c36d2ff7f5d114c5a7e85fb0f6edde420b13e0499df7b416121167f2d66b84a4"
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
