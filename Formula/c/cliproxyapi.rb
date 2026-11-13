class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.69.tar.gz"
  sha256 "4a08df3fed4976837e826a83acc47c2347b5136247e27398d61e08b035b7c97e"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "c99d649208a4133803970f7e0b9de984a55d047420f1891c36077e5b199c36e3"
    sha256 arm64_tahoe:       "8cc7c0f1c7cc4eaf47c810dc8ebf27533ac58d6420e71956818c1e3ade5b6d6f"
    sha256 arm64_sequoia:     "96693aa0c03d9077094c635d5e57e742e79f86d1c766f255b40bf6d3092fe494"
    sha256 arm64_linux:       "68f51e0636570438740204d1073b79b4d168f992a3c517a49aeff0dc168e44dc"
    sha256 x86_64_linux:      "a5562bd5e654d90b5fc3ec53f7232caf0bca3215342110479e27f7f2dd1e6352"
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
