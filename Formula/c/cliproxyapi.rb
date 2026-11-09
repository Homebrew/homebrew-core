class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.61.tar.gz"
  sha256 "90b3f7cdc38acf6b33b4dbadff420c7079ec5cf92f72183f4c13991345ae64b8"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "c0d0b01adfd6f2beabb005cadfcd94c9ad0090bd69b2b59c1a7be305e3a1b141"
    sha256 arm64_tahoe:       "a87bb0b6cd8f614075768e7ec1d18481529f39748c971c8ec8931dbff71b1d23"
    sha256 arm64_sequoia:     "44e4b6587ac2e7f8f131a48ac97fa4750393c626f2ab2e199407d1a22ebd3b50"
    sha256 arm64_linux:       "27862dc50939c3c2d539fc5ec3c2375a74447107ce9edf29470b24d290f29fe1"
    sha256 x86_64_linux:      "1d04e6efd590ccd4f553fceb97ec1867299500cd1be61306b889c8563d9da7e0"
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
