class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "f750d834d76f31a846758f65e421eba4bd1436915e2e5d4887288a1f558e6d45"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5, days: 2
  end

  bottle do
    sha256 arm64_golden_gate: "bd4946c8eb5691617c39c8a0bc56d239fcbd43fb8877908dd0aff4979f6c5b76"
    sha256 arm64_tahoe:       "0f54752d1e431b511a5281181290a69cc85834648ce5a3ce01fe13e0f3f3fe4f"
    sha256 arm64_sequoia:     "b12f60dd71d8336d3a43f020ec46fd28961fdb28c29b35cf62f6b98a8cd39892"
    sha256 arm64_linux:       "eae4b50cd9ff4054e91c9727f446cdb8be389ba663625d2d91e1903837501adf"
    sha256 x86_64_linux:      "6009e66c531122088e51c8280432c18a050b775d16283a92f608081e682527f0"
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
