class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.60.tar.gz"
  sha256 "bd07b2c9859c625fc528263294d06fa5dd08af6038782d6d69028f6b1e511db7"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "b7ff661d1e82c5837f886fc6f68c7b6016c99c5efedd1c46129232698a0d5470"
    sha256 arm64_tahoe:       "5cf62c72ace4126679d237377f91939f07e356244a7a502bc64f88869d45273d"
    sha256 arm64_sequoia:     "77dbbde02c362654e938a04334ace4b5928c1919d43692937781c3f48b6c8791"
    sha256 arm64_linux:       "c402d39ae393e8f8bb4328a7aa1941e563c46053c6a3a0fc61de271d834cd1c4"
    sha256 x86_64_linux:      "da1f5ff5eb1e696bdcd3bcd2201fcd96b0f74d0f0c4d0dbb8ee98eeefeb48f56"
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
