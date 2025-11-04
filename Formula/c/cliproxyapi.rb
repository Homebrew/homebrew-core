class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.8.tar.gz"
  sha256 "ac220a8636f7330dad5011db8f5de0f19cd39d8fd7e55b987832be6551cf803e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "49e0f324c934122be1363fbdd409527fd41770fa8daebd15a44555b76a20b12f"
    sha256                               arm64_sequoia: "49e0f324c934122be1363fbdd409527fd41770fa8daebd15a44555b76a20b12f"
    sha256                               arm64_sonoma:  "49e0f324c934122be1363fbdd409527fd41770fa8daebd15a44555b76a20b12f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8354163a50f15f7bbc60718482d29a75a20cd84fcc7f501307a60315be9c0336"
    sha256                               arm64_linux:   "c5262292e3a1f1c89a78d9ec625cde5ca8c38a1fa249a47c795ca88bec54e55a"
    sha256                               x86_64_linux:  "f00343ce7a9866e8084ad7299041dae75a4df2a0453cbf01936d9a083b4ff693"
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
