class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.1.50.tar.gz"
  sha256 "8e688c081fc621dd2a31d15b01fe8d9983e09edb040d256753353deb836b48bd"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "c263cdb5a9fd4632c981cad215621e77171d6874ec2dfd63227bae30da3942df"
    sha256 arm64_sequoia: "40ad7bf7555283305d9507d876a9003e612fc57026a1e1eb42f2bf47ac2886d4"
    sha256 arm64_sonoma:  "a6447a6101e2868bca0eeb6e406a40b0a7b9ca1851e47058b7b610879ede0744"
    sha256 sonoma:        "ccde8029d47cba591d703dcaab1e741623a10c4338609aa9def5d4466cbca032"
    sha256 arm64_linux:   "bf0f0ffc1c5a0515802b9293f94c7c9f2a838b31a86eba8750817e06473ddf51"
    sha256 x86_64_linux:  "3dd594cf6cfe62457ad7042ec888a9c6748ea0931f5a0224525662c8813d11be"
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
