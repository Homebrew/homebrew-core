class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.20.tar.gz"
  sha256 "a284c7daab25b2489bff3a8d674be487cdf2bc23400ec8d5da8efa9a52e8e8ae"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "9d5fc432331ef0aed40856f8a95453bd5fe1f13e9e44f3acc02d007fef2da4be"
    sha256 arm64_sequoia: "9d5fc432331ef0aed40856f8a95453bd5fe1f13e9e44f3acc02d007fef2da4be"
    sha256 arm64_sonoma:  "9d5fc432331ef0aed40856f8a95453bd5fe1f13e9e44f3acc02d007fef2da4be"
    sha256 sonoma:        "6853c0139e46f38d6a78e284dc718fb98401a17014b72697db808670280bf71d"
    sha256 arm64_linux:   "fe92d4f2b8d1940096346b35e965586be18231e8d53a78e99d2e54432c6b91ac"
    sha256 x86_64_linux:  "6177cf61faf48a155fc212639c31c9f3b85c174f0cac17a71611a867caccd1d7"
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
