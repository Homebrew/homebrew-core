class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.50.tar.gz"
  sha256 "213ff8a7ab86ab81fb3f173f5e108c5dea1ce3a2cb790b75d16dc296297b7813"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "d3ec8983c88446680d3e0350079b2455370b56b6ed24be83777e5c5ca8b06e22"
    sha256 arm64_tahoe:       "442e20efe3baf2cd47f37ac2c7d76e5a64ed0ee4bc71dba44c0dca78cd46570f"
    sha256 arm64_sequoia:     "b4138b8baa4766d8d6c27fdc0282f81d99082cdedba2a7114c1cc4ff3ece4570"
    sha256 arm64_linux:       "29776bb05058fa92ab388aeacc2270396b0be9e6a98a6ca055abf428661935f1"
    sha256 x86_64_linux:      "838725391e261960cc170950caf8b1ccce7a4eac86c78f9c9e37f8c5860b0b8b"
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
