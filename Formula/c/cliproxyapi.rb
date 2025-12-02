class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.32.tar.gz"
  sha256 "0a700632e6c7f715245e97258f4cbde7cde4bc1b707be93f55236260e9ba79f8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8ba7a53e184582e88f8d75fdc3394ef568066fd503aa402b0e1cd5c67fec0df6"
    sha256                               arm64_sequoia: "8ba7a53e184582e88f8d75fdc3394ef568066fd503aa402b0e1cd5c67fec0df6"
    sha256                               arm64_sonoma:  "8ba7a53e184582e88f8d75fdc3394ef568066fd503aa402b0e1cd5c67fec0df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "61e414839c22077d7ecf3f3f725f752e6e4cd16b68ba7f0ca40d17852b4661f6"
    sha256                               arm64_linux:   "01c4fff2b76325285b794d6f66a3fd886a1450b272e733cd8abd2443c612cabf"
    sha256                               x86_64_linux:  "70afc7ed860fbd4b62a9afcaae9de6a3431da6da7af8dd29625eadd9bc83b65e"
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
