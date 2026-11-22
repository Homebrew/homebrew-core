class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.0.tar.gz"
  sha256 "cd784e7846d33805c74e2912b3166c6de705f674e8d766a0c15608b30675343b"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "1513bfc78fd1fe5d9f23af9ca1c89ca45809a04e287de4bc50788bf70e29ffa1"
    sha256 arm64_golden_gate: "2457d63c62844f7b709797c286d6fe91c6e093c886b2f7feee180f1c3a98c87a"
    sha256 arm64_tahoe:       "5d75c5c45c5ea75ea8465d96db58576b58889d7136994ebe8b14e01884058120"
    sha256 arm64_sequoia:     "b705aac03dce571231e0f9f58ae70da235c4881e22e5dd04d947338c7044b683"
    sha256 arm64_linux:       "b7b38f7ee5f5d2ad8db9938856a111d81e9060c3b21f18601cc2f77d7123714c"
    sha256 x86_64_linux:      "e4fad806589d16b411ab082349f1da815e38d2b13ae896dfd33cd1dab09b0811"
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
