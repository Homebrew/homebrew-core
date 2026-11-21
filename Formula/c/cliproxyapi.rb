class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.80.tar.gz"
  sha256 "7d6d050e857ba3ea9e9b2daa24adbfb401d8b67758e047d7fecb611c9735d637"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "8e39f040a6295b0c4b5be8768fb26b72930db664cd6a5a38047e77d9bc372c11"
    sha256 arm64_tahoe:       "585384aa12c59b76bcb6491a7dac529adbcd1800896453af2221f36261c95bc8"
    sha256 arm64_sequoia:     "1e45850c2c4ed81a4bbf15848461f451e4dd491b5d776807ca3fca0a9c150d3e"
    sha256 arm64_linux:       "0e6278ff6237f8b8d98084285c1ed44e354b68100769c0d02efd86525c78f8dc"
    sha256 x86_64_linux:      "553b61ff061bb1a235f1238a4021d871105382007a1bf8f9129ed7c3f7a0d742"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
