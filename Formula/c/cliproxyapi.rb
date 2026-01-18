class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.5.tar.gz"
  sha256 "c3b1798d7c0b3f3d50c32cf3ffa64db70187933c0a4c45ded95ef347778e709e"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "3202d64ab55432cb21fe52c7c83509b001bbb5c54e28023a9ca54807280688ac"
    sha256                               arm64_sequoia: "3202d64ab55432cb21fe52c7c83509b001bbb5c54e28023a9ca54807280688ac"
    sha256                               arm64_sonoma:  "3202d64ab55432cb21fe52c7c83509b001bbb5c54e28023a9ca54807280688ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "508a9e8107dc92abe29842a98df78eefee4d38029a260d68f3dd567a3b4ec44b"
    sha256                               arm64_linux:   "0279ab300ca04bdc9b268d3b89cf23fc43f12a1509381ddb45fe333d4d64b6f6"
    sha256                               x86_64_linux:  "4fa2e5336f0109e18d0c7aaa2d30ae8f6512fc9b84f3e57cf1650f2cebf300df"
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
