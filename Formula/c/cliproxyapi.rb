class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.15.tar.gz"
  sha256 "ce396035065abc4896b045631c942eed78ced92806095df3a93f38d0c3cd448a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "cccb1b6327c9dbe9a5e34e3095b20b93e125a4c716c7df77a9c51138ef3cb9de"
    sha256 arm64_sequoia: "cccb1b6327c9dbe9a5e34e3095b20b93e125a4c716c7df77a9c51138ef3cb9de"
    sha256 arm64_sonoma:  "cccb1b6327c9dbe9a5e34e3095b20b93e125a4c716c7df77a9c51138ef3cb9de"
    sha256 sonoma:        "896a46057b6c65cd9a847a3f0bb05d224eb5faa35e3eea1b596c6bec1088f8ec"
    sha256 arm64_linux:   "d2109935a25849333092f6accd286865b63f199dab02dbf7db1f262242eec179"
    sha256 x86_64_linux:  "b393b257a2beb087df604e7df4b26692887bd097981e0523632ed1968a199259"
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
