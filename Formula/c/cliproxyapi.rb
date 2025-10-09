class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.14.tar.gz"
  sha256 "94bfe73c8efc48ac2d6aaaeec49eaca8ae8f5e9d3b3f91d0793151336009020a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "516869b6471805494bde584f4febea63a6ee712c396d5f4f3c5344f3f48ab72c"
    sha256 arm64_sequoia: "516869b6471805494bde584f4febea63a6ee712c396d5f4f3c5344f3f48ab72c"
    sha256 arm64_sonoma:  "516869b6471805494bde584f4febea63a6ee712c396d5f4f3c5344f3f48ab72c"
    sha256 sonoma:        "0c6e1fcc5365a3bb65ce0bfafc4c7bd66dbced60bf652559a0f160c5b65cca80"
    sha256 arm64_linux:   "f052723bc8e46e545ecf99bb5934872c7dfb2b102bf3daf0b03dcb9410a07aaf"
    sha256 x86_64_linux:  "d44a8a39a88158bec6a278edc54f7c1f5a9550e8958bf001a22c76470c10d56a"
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
