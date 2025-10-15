class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.13.tar.gz"
  sha256 "b504fd5c9c7cc48822bd89b8bf684b4758ba12f24c595103568560480bd2501b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "bb63b007795411c3a1168aecee9d1a15685c45ba1a303756378d935263fc40ff"
    sha256                               arm64_sequoia: "bb63b007795411c3a1168aecee9d1a15685c45ba1a303756378d935263fc40ff"
    sha256                               arm64_sonoma:  "bb63b007795411c3a1168aecee9d1a15685c45ba1a303756378d935263fc40ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ecfda19ae65351a801000855c6884fad213d9edf4df648fc5682a7e9abf75a3"
    sha256                               arm64_linux:   "69cb9d107db5af0946be4b51fa1ce41f4fe6a9f5be25bca59a0cd73ed8344504"
    sha256                               x86_64_linux:  "fb5ff0e233f8dfb1f4d7cb8f6aa140c28b383f48986297f2fc72ddfe99d82965"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
