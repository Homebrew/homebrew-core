class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.15.tar.gz"
  sha256 "33d25e58e9810e7653e1b0922e812accd8ce884f8696c98456328c68353d66db"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "b05ef4c6cc55241e1ca64f157a02e4069f956ee3f636cb5c1da643751234f910"
    sha256 arm64_sequoia: "b05ef4c6cc55241e1ca64f157a02e4069f956ee3f636cb5c1da643751234f910"
    sha256 arm64_sonoma:  "b05ef4c6cc55241e1ca64f157a02e4069f956ee3f636cb5c1da643751234f910"
    sha256 sonoma:        "a8fa988be269998866339ead2d943530f35c86b2f5041f59dff1680188824b92"
    sha256 arm64_linux:   "e5a4e833247265ede99acfabc5c62eab8015f09d6144859ac44ff9e10cd3fda4"
    sha256 x86_64_linux:  "65a1c314d298435354729f3e86fc4a6d19935bd0321ecd0ba21ee908e7cdf6cd"
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
