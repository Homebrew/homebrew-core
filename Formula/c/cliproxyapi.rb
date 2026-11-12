class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.67.tar.gz"
  sha256 "a7ef01a93bd2486d7d3158a47e045d211f9cdd8cd39a6172e59ce64e0e952d32"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "aa2bbe4868fce5be95aa61c022480196358b6052c59ccbec469d245a1af967f5"
    sha256 arm64_tahoe:       "1c67782cd911e571be0bc7324537087c1c5bfbfa1385426bbcf1b434a1c3839d"
    sha256 arm64_sequoia:     "d4be40889e6982e37839f4fd9cc491ecff85b3addd15c84b6a7985cdcaa8fd06"
    sha256 arm64_linux:       "067b0d3eb5b7dd4556e501f8adc202f3a46c695b9981249a722e5f6363a792bd"
    sha256 x86_64_linux:      "2b064f771dcfe781248f725cc036cac946738f403409267ecffb818cf3032c4f"
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
