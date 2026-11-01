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
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "2d8adab53171f69ba62bf164d26ea7b73a9de1abd1b84dd7794653bb28e1eb7d"
    sha256 arm64_tahoe:       "17b3a3828a9c934b4bf684b59e922600e73d3852e7a7dda0247a533abd7454e2"
    sha256 arm64_sequoia:     "b4179f2584dccfeae655dd18a8ae0a10ddabcb3eedc097d2208866bdd4802528"
    sha256 arm64_linux:       "3fda310459f8f2104d453cc9fcd10ecaba9b6ebbc5d3800a2ee5ac1619b1f78b"
    sha256 x86_64_linux:      "ccff92a545f5639a35d11fecbe601e9d1a93dd21bb2cb632612d49d9a0da5fa7"
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
