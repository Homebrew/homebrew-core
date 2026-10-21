class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.35.tar.gz"
  sha256 "aeaa3f3852321223aa62d5c3a912fb15110b3004add3e2490a5d31398de9efb0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_golden_gate: "89b9f9d459cfcad9bd2d3ab17a311ca5507d6853ad74cc35b17279fc094ffeee"
    sha256 arm64_tahoe:       "8e98d60d72b32dce37782c7e7c5d0f175e11825825220467b4ab6cc5c954ca46"
    sha256 arm64_sequoia:     "a77a75667cac8b615260ebf300d57bb0cb2202105778207b7a22eb246766e4b8"
    sha256 arm64_linux:       "386a97b4fbda1cea8af7e51843c9db1fdbc6874d8117e8a7b68c93e860257eef"
    sha256 x86_64_linux:      "8d7547b58b2c92bca8d6b323d16e64bebf5036e46269d20bf7643c75ab83c1ab"
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
