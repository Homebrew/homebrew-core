class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.51.tar.gz"
  sha256 "353caca32c8ef89a90d8cd77abd1e1e9bcc1b4e0f6ff958edee53fd0e2a074a0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "b6f6125057c1c696c243c099e8b0d517134a4347451b551d633618f1d1aeab71"
    sha256 arm64_tahoe:       "7c8fc9f1e73489e5e1d5da9ccb0374a74d404fcc72836499f78bcf61ed43f546"
    sha256 arm64_sequoia:     "1dd544bfe40e6263aec0d6a56ed8f8d516a34a701d6cb5d94ee0cd3f4ebbe3d7"
    sha256 arm64_linux:       "66baf0fd6672be52f8e1ad8028fbaab933e56d71edcf0fd29384e4de23ca7a5a"
    sha256 x86_64_linux:      "0c99f15adcdb7cceb5f0dd9acebc8c49a606e158d96ea3c113eedc325f1a7470"
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
