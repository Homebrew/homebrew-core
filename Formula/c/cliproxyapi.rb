class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.20.tar.gz"
  sha256 "3c0dacdf6195a5f7f6cd9c2a7d388c168ed4d0fa14fafac62f6228710e339cf9"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5, days: 2
  end

  bottle do
    sha256 arm64_golden_gate: "20d14e6aad039cc2681d4f14ed03f8779524a528815f5f157c86d17ab7d837ff"
    sha256 arm64_tahoe:       "fb65312e0ef9b055655bc9d9c4aeb9a35ee1f128fcd59cfc7d98d558332ec3dc"
    sha256 arm64_sequoia:     "fe9344c27aebc1a15006960f996716835553763148d2ec6336eaf3bbd3f33b63"
    sha256 arm64_linux:       "2a1f3cd2d486859bdc784f764e008a2fcff1469da9afa1b5c8ba0703906df7fa"
    sha256 x86_64_linux:      "060a06bcf2e1e002cfaf98dd8a1f7a08773bd7def07ba0be6e546f7cfd63f420"
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
