class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.5.tar.gz"
  sha256 "7647f27ebf152f083f1dab68dbeade7f7aa832245cc7b17d5693134d4198deb1"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "7e616521c247b773b626072db9c8316d98bd662fb97546e1c2191b9c6797a420"
    sha256 arm64_sequoia: "7e616521c247b773b626072db9c8316d98bd662fb97546e1c2191b9c6797a420"
    sha256 arm64_sonoma:  "7e616521c247b773b626072db9c8316d98bd662fb97546e1c2191b9c6797a420"
    sha256 sonoma:        "717601883454f9717405a3da3d5b86a9b7f651a2d71c02259756c1dc3ee89bbc"
    sha256 x86_64_linux:  "7bf823cb240005b045822b4cdf5443f224938d3dfad108885847f42bb1776f02"
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
