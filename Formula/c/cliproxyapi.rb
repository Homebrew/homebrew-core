class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.70.tar.gz"
  sha256 "30a69ac45543ec470cfa17fd2c868853c625b6f3c9404de101750c8cd11f170a"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "155e2175d3de3f26c6a5a40364a42f264a492b57253fd8a1fae7c3d2e86fbcc8"
    sha256 arm64_tahoe:       "7fc9778c7a03e10ff15d548d534258645c588d6054c56184821f5ec5b5b2c96d"
    sha256 arm64_sequoia:     "a549cd63a4340c5ee85b87325627e54d4e75a36dc2fcf4750300630a6f52d260"
    sha256 arm64_linux:       "88baa90f680b161510e855fdb4002f83d9df29af2c2a3fe4dfd11ec83d48fa9d"
    sha256 x86_64_linux:      "3ea0c77bd103c99fb1bd3a0383942bb92950bf97e4127d876bb3c1fef72d3c6c"
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
