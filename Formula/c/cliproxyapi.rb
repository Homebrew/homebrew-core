class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.76.tar.gz"
  sha256 "d40224c4239bd6b9417c902079fe69c9a923c227bdc7ca41fe31414bf41329b1"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "6b8580bde98d7a8d1eca3540668a9acb56e17473bbb2e133ee92db0b0adafda9"
    sha256 arm64_tahoe:       "c6790b57bc217729f6a61f70d5d908ce2b61c8dde69346205dfd5a586ea849ac"
    sha256 arm64_sequoia:     "0a11ed4fbf6665441819a3d02a278907a3feb16fe9585b856d4d7a5129bcb0f2"
    sha256 arm64_linux:       "a12fa57eaf23689f2d9d83c5a0524fd46c57b4c690e5bd76f13d1e68713af80a"
    sha256 x86_64_linux:      "750dcc41da10661ded9673982910af2c764f9badb75831ef1d7fe44eef3c3c2d"
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
