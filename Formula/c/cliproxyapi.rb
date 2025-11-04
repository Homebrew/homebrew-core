class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.8.tar.gz"
  sha256 "ac220a8636f7330dad5011db8f5de0f19cd39d8fd7e55b987832be6551cf803e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d29f7ea678b160994f4162eb01ad74fa9d84ca0ee42afbbf10c606e9f17032f7"
    sha256                               arm64_sequoia: "d29f7ea678b160994f4162eb01ad74fa9d84ca0ee42afbbf10c606e9f17032f7"
    sha256                               arm64_sonoma:  "d29f7ea678b160994f4162eb01ad74fa9d84ca0ee42afbbf10c606e9f17032f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e5e328df8a672efdaa8d5a054cc6e843647bb6eb5b3e1e2e357a735c300d971"
    sha256                               arm64_linux:   "ddd61f84ab989279ec2d6e0821f8ba0dc535e873bc29d7a01764e26c525a4a09"
    sha256                               x86_64_linux:  "e9cba5b6cb5176540350f416b44f5f02da0eacd43bc3a66dbd979ab4171d7553"
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
