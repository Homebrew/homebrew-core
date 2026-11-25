class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.3.tar.gz"
  sha256 "fa3839fcec383a524ffef20ab290f1c7cb0f13659da6ae2e96d00bbff91ead07"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "727fdccfcc7fd246a7a38beab76412b9ac2c2ae7782d812d52576476a6856287"
    sha256 arm64_golden_gate: "448b5a999446a66a1903d7acc69aa59cafc1e0a36307ee69d524b988c1423544"
    sha256 arm64_tahoe:       "8c7506c1db823729e8df11e63e9c6a066b10fbc38635e1da4e348fa6a6af2eab"
    sha256 arm64_sequoia:     "6677fac418001e4851d04b2fd9a97ed384b404daa96b5bbbc8d712cbf9894b74"
    sha256 arm64_linux:       "3d2a0a1b8a6d852021442b2881b0d0bd1f1e66c1660a42144a498191d4d04684"
    sha256 x86_64_linux:      "9abfbc386709db22a409a09a42270db5633af863fe77f656c881d9a3cb3e105b"
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
