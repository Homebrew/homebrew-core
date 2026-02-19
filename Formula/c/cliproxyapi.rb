class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.20.tar.gz"
  sha256 "67025e669e5f17f66939cd4d1f3045fab5135d918fd5f25f88705e57964a8853"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "6dbc61663aa0f9d068312298e1651b0949ffa08f82de8979de86b8ecede5c9f6"
    sha256 arm64_sequoia: "6dbc61663aa0f9d068312298e1651b0949ffa08f82de8979de86b8ecede5c9f6"
    sha256 arm64_sonoma:  "6dbc61663aa0f9d068312298e1651b0949ffa08f82de8979de86b8ecede5c9f6"
    sha256 sonoma:        "662beecb17d2ccd0b198bb9a755c4c0139a3e63c792088eee8aa8f5f348a9f79"
    sha256 arm64_linux:   "577a1c8e096c13797eeb8c6b459f386b738a690c62cf3be4c9a626e4a3d2cbd0"
    sha256 x86_64_linux:  "220b06858fbf4538ae7c3640a969795017556deb5e91b19954db5ed45f13fd7a"
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
