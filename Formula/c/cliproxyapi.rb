class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.7.tar.gz"
  sha256 "5d2212c1419916705e502e94e2437b45223d220cbfce901c0aced3d19b0cf0f9"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "a556b0dd29e6b10e5cbace4f59b5dcdd118e8871879d71e9d8c432add973f532"
    sha256 arm64_golden_gate: "7723d47196891155f775f8b041eefe24854daf43fd885eb1186de10bd518103a"
    sha256 arm64_tahoe:       "8c7e9eda0bc5b4a3e3ee4eb27e58209bceb79fc51a5946e80ee5147f9b783b35"
    sha256 arm64_sequoia:     "59f3d1dba160c52623342a8658e331a7d57c4e7dd17944b5e42495e0298456f6"
    sha256 arm64_linux:       "d95b1f745f069294f3ed77417b29951dcaa451c96fcc4f245d7ea6776e249b17"
    sha256 x86_64_linux:      "4573205337e3b0420447bf5fd7382f426916c249bc099956fe46b03b300bca59"
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
      -X main.DefaultConfigPath=#{etc}/cliproxyapi.conf
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
