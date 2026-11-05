class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.57.tar.gz"
  sha256 "f856605471bd4e4d406595dfe36ec08852371a2db78520b99850dd45f970e915"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "66dfc37d9992c7b4760e81d52cdca2e34a75c6708759e158c059e0324015d946"
    sha256 arm64_tahoe:       "7555dac1bfa24779ca5daa87a9fd3c9757a3645c2e24b2abc64b3959a31f079b"
    sha256 arm64_sequoia:     "7d82c590c047fc78b6d07056bb001308406824f4b3f3636a9d069f878bc63b4a"
    sha256 arm64_linux:       "06d32c577d31335eb4f34e5ac383e4b94ca2fce8730c5c7dfe02c109fc493ed8"
    sha256 x86_64_linux:      "6347af225bc43398ac2f3c06386d85c876cef339507ae4d93ec04bbe57821d69"
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
