class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.10.5.tar.gz"
  sha256 "a60f981c57564681161157d00b3610305eada5c6efa06d078107cc45569f15eb"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "177d6216debdf60bd095dd12b3e22fa538b4c8fb7af36aca0746517e9b692d7a"
    sha256 arm64_sequoia: "177d6216debdf60bd095dd12b3e22fa538b4c8fb7af36aca0746517e9b692d7a"
    sha256 arm64_sonoma:  "177d6216debdf60bd095dd12b3e22fa538b4c8fb7af36aca0746517e9b692d7a"
    sha256 sonoma:        "1a6319f0b83845cfaf65e1442e2b05f42e77b5cb19a82547b095780dec3286e2"
    sha256 arm64_linux:   "7908d03d2d9ea9f89e7cf4be92bb95fc39ac2b74ffe98cfb7c2ba6160dac57e9"
    sha256 x86_64_linux:  "cefd917d10d0780f03e407cdf898981fcbeabb6fe16d2204b25d50f11be02c80"
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
