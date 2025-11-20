class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.4.1.tar.gz"
  sha256 "b9ee4d14a8ee70539e6d6a37f43f0de93a409dde52065a1524a2a06b2536220c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "28d7bc0ef9a95253bb0d1f5137412cef8267ecb3858b9ec18d29dff0d7d81386"
    sha256                               arm64_sequoia: "28d7bc0ef9a95253bb0d1f5137412cef8267ecb3858b9ec18d29dff0d7d81386"
    sha256                               arm64_sonoma:  "28d7bc0ef9a95253bb0d1f5137412cef8267ecb3858b9ec18d29dff0d7d81386"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ab889037a591ce236144281a21e2db316bc3b8ce885317335fa216039233692"
    sha256                               arm64_linux:   "3843e3ed877b7c7f06aaf71af29ba57a3fe1013fbf75c33d4a489dc77ea4bf57"
    sha256                               x86_64_linux:  "4634c05f73032073e74b18f8289fdcd4f9d3ce92c788132c4b6fa5ea95836480"
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
