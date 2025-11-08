class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.20.tar.gz"
  sha256 "1f2cd2fbc0dfe88e87393a077f4bef068647da34258cdfef449271fdec76edd3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f139bbe2460faa95d64209f0b9241febd94195868cf8018c28796f1a8d4a08bc"
    sha256                               arm64_sequoia: "f139bbe2460faa95d64209f0b9241febd94195868cf8018c28796f1a8d4a08bc"
    sha256                               arm64_sonoma:  "f139bbe2460faa95d64209f0b9241febd94195868cf8018c28796f1a8d4a08bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "76ac33fdbb7df0d2c1dc165e45e465658020b742526ac715deaf682269dd7518"
    sha256                               arm64_linux:   "d88d796b8235ae245063164ed19cead54d7562cae01c082c1fa5076877c3ce90"
    sha256                               x86_64_linux:  "b5d4bde90876ab363d3423aedc4add724a2fa1b6246829108251358fb8025a06"
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
