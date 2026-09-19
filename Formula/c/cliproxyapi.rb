class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.3.5.tar.gz"
  sha256 "2a9e6674a1b8d5565a23c43fd2155bd3584255e20f8e112dbc89183d05bfa0ba"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5, days: 2
  end

  bottle do
    sha256 arm64_golden_gate: "ebd4698e1eef0a1915c8c1df894c881717a56c6e06db39620010b042116a2e0f"
    sha256 arm64_tahoe:       "2af5a87a55467d89a7653e10ace6c73dbe1a7ee4a3e65a34a34fb9bab7d5f3f3"
    sha256 arm64_sequoia:     "8e39bb12ca5645b12cd520d2e15de030ded745fe666eb1e5e5e3f99ab89cec2a"
    sha256 arm64_linux:       "23ef0289a94192a4aeead8c3a37f0e95ecc6e453bfad366c2434fcb85acf8530"
    sha256 x86_64_linux:      "4ba39be8a0cccfe40adc55b91acf3c8c15d7749f05ffe63fb7f4989f973503d3"
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
