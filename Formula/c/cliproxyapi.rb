class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.72.tar.gz"
  sha256 "610563893daf77ebae9aa2fcdab097152f6324230a96dc95257dcb04e0d00097"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "bf1be1fe3b6f4a71efc4f0b234626d630a6a858e545b74cd64c4b867d7225b51"
    sha256 arm64_tahoe:       "87668c52cbb071544b0d7903865bd2d3c816e72c7b4f436e0b997f56a9f42e8e"
    sha256 arm64_sequoia:     "cf03afbb33b3f0beafcf0ad14cd8628d07e00c3cfad9f789b3c2cf332b05b722"
    sha256 arm64_linux:       "57372ba9f669ec42a633848e7098d5f13d9081ef3cfec3c165c8f993f91f7595"
    sha256 x86_64_linux:      "e3e905a31c7570035a146b0197269df220de051b25145e6670c79580ffa69fc6"
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
