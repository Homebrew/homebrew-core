class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.54.tar.gz"
  sha256 "2733ec32b84e3281005c4e580a6034c4237193fa8dacc12c81166167dcab2c90"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "581d9ccd63aa5db9331d60b4c27d314b4e7b6deee3f4aa0a523eb58d31bdb7b1"
    sha256                               arm64_sequoia: "581d9ccd63aa5db9331d60b4c27d314b4e7b6deee3f4aa0a523eb58d31bdb7b1"
    sha256                               arm64_sonoma:  "581d9ccd63aa5db9331d60b4c27d314b4e7b6deee3f4aa0a523eb58d31bdb7b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c70e7b58a0334713078bc5eac20d9a0c1c54c4f8bb5da840f85d1e87516f716"
    sha256                               arm64_linux:   "08651c79bc0f0cb2a6fe6eede6442d1493ee4fdf6d612645a82508ca042d1133"
    sha256                               x86_64_linux:  "bedc276f54b5576922a4bb62610b5140daa2a0efa2ab5e234a14cd2ae931895f"
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
