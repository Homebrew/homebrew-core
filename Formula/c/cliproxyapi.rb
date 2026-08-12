class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.130.tar.gz"
  sha256 "a10e3aec2e8219f41c65d035c4d8b0811b05ee2a5249d7293128b92d3d261784"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "70a9545e79994d673a88f80bd98375344819fe6ec84f73671f94f2aa4d19ac9f"
    sha256 arm64_sequoia: "1ac0cd94ecdbee9a9b2aa193d0f843ebaf931c8c21e35ad750f22740cec353da"
    sha256 arm64_sonoma:  "6f7b6d6a1b8d43dd6b4e8f9b23408ed394c2318ee7d0625849d207a5a262c253"
    sha256 sonoma:        "81c98bb83ff9502d83c60c407ad3596b6acd129ec85ccece9e27ebe8abe3a741"
    sha256 arm64_linux:   "fae16264ff1eab01d9bc358fd343dc8cf820e78be8c4fe49460241e6ef511455"
    sha256 x86_64_linux:  "443a54ef1bdba2d9d320d8bcd8a3a1b025fd7680162ce0ae3b380dda45cf71f9"
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
