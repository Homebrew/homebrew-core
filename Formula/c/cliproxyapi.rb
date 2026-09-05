class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.150.tar.gz"
  sha256 "728ec52ad4d2ca172111ae5d335d6d706228e2ab3e09c6d9151c7c9c090c74f6"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "0f44b4d171fd6a3fd99117a905352fb7305f666736b5b41bd0e6cfd216449a4c"
    sha256 arm64_sequoia: "4dbb7d9d448e765ff68417979c4507d7a488a5cca3ac7a5b7265a5a7528a93cd"
    sha256 arm64_sonoma:  "f4d7bc36c75e1fe925c0bf4fae9206ef1426a702b20bec963d67889edd217e87"
    sha256 arm64_linux:   "4ae96effed81e02dafc19744a12fb7bb1119da54ca38fe8ac50b3a3c549de7f9"
    sha256 x86_64_linux:  "7b711d60f25afe59766ef582385f4125ed38fd61336f0909e1622091a40d8f45"
  end

  depends_on "go" => :build

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
