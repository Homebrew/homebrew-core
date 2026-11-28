class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.8.tar.gz"
  sha256 "0c826f707718bc476531f67d9ef94e90ce74f1dc787f8121c745078f950c0486"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "15fd1871164ea4332291e1ecc1e2eb6b6e588441d7ea9d901941d74c49f1eba5"
    sha256 arm64_golden_gate: "4b726eed9896803d074e6a8cef5b9f7e939074ca097ac7e997b1a3a9597002fd"
    sha256 arm64_tahoe:       "cb3e56527c98e9e1b9df1bd485f150cdbf1d943969d22286e9f0e33f17f9bbe1"
    sha256 arm64_sequoia:     "08037bdf9046a775c70f5f3636c07fea2fff713f783114919342f50172e7338e"
    sha256 arm64_linux:       "557062b0c2f077e1f0135d33bb65790173d4ae1fc1dbdb94b2efffe8b26b1e23"
    sha256 x86_64_linux:      "a0be823a8132f7ebb16bdd9cba209fae6044e0a67e45387e61f3b925a864004e"
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
      -X main.DefaultConfigPath=#{etc}/cliproxyapi.conf
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
