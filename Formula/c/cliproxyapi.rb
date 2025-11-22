class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.8.tar.gz"
  sha256 "6ec59be1c0cc7d77d4bbb1b7c2c0ec7ebdb37072f886d5a2373fd2f46c129f64"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7a1f28c1fa5d7cb57bacf30432d3a503408f635b16e165e012d5ac15b0642b4b"
    sha256                               arm64_sequoia: "7a1f28c1fa5d7cb57bacf30432d3a503408f635b16e165e012d5ac15b0642b4b"
    sha256                               arm64_sonoma:  "7a1f28c1fa5d7cb57bacf30432d3a503408f635b16e165e012d5ac15b0642b4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "249252864226088f7f6e449ce09c6837dac3fb0360ea6ddd698f9c46f04ad611"
    sha256                               arm64_linux:   "e85d4641e7b17fe69e52fda331a153f8f32f8afea99ef36f87f79995434f1b88"
    sha256                               x86_64_linux:  "d658d12a519974b1f3a863b5828572b7880203b327a01d42adcbc3e5a2c64c38"
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
