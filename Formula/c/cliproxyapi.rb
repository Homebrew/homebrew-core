class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.79.tar.gz"
  sha256 "25f90297c5737a323cdafa7a58624c8cd5f66fad42fb3890178f729701c16ea5"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "e17f7588e43012b868615ba041da8488c0c9c41d9a8c20f8c4c119559daf4e4e"
    sha256 arm64_tahoe:       "69e72051dab0b3036601f039ee3f07b7e3a71f9782ca8cefea9d2d97c4f3f96a"
    sha256 arm64_sequoia:     "fe0b55b67f1949bed0894114ee4d647d083e5831aea16a9347a9dd79f8c65e37"
    sha256 arm64_linux:       "25bb1d87fc28c99bc444e55daa6d11be57ffc511f80aec612eeee0bc5c3b416a"
    sha256 x86_64_linux:      "80f995412db65728461ac93a70ff7b99591e08bf01775850000483dd50206e52"
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
