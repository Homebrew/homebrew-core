class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.0.tar.gz"
  sha256 "002dcac0ddae009d0d6bc7ce2678092b9fc78e8cbc8cd618bae6884989c030c0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "5e4fe17e0fb66c46b0107458aec48d8bbd685df526981471e2cb166b82fd9e24"
    sha256 arm64_sequoia: "5e4fe17e0fb66c46b0107458aec48d8bbd685df526981471e2cb166b82fd9e24"
    sha256 arm64_sonoma:  "5e4fe17e0fb66c46b0107458aec48d8bbd685df526981471e2cb166b82fd9e24"
    sha256 sonoma:        "6e14882d58588142a166ac3b17a2d67f08fe7125080eb3136da29fb8c7cd94e8"
    sha256 arm64_linux:   "7cbbf91c30e01a5e42eea426ee7526fd25a15d55eedc7650721c6797b3e7e5c7"
    sha256 x86_64_linux:  "d4c73e1d594cebfa5dd1632d5ceb3d43315c7f45dc1a01931dd17b5e2d989b4b"
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
