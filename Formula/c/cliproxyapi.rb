class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.7.tar.gz"
  sha256 "5d2212c1419916705e502e94e2437b45223d220cbfce901c0aced3d19b0cf0f9"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "7269ab626563f3493469e4dadd4aa047871d70de6358978d17382c41af75b244"
    sha256 arm64_golden_gate: "75fbe0764ce5b68921ce6d17b643342396d9c58cebcb35261030951624bed9f7"
    sha256 arm64_tahoe:       "6434ae8c407401b6d74110f1b9971638488be2f884239be27cb6f6b4bf44d52f"
    sha256 arm64_sequoia:     "9c9c849ced62bf93b1e5c5fa2f6bc5d3d7f596c8340d1d04673c3108c3dc0d57"
    sha256 arm64_linux:       "72de2e628287dc79fad3f7929403e2358e98fd6a1717400c7a9926954715406f"
    sha256 x86_64_linux:      "34030efa50c0a2704199777ba4ba45832e606d98ab02edb22112ad9ecc7c8a5f"
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
