class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.5.tar.gz"
  sha256 "e4b2c15ac3da54b07446993119a06908910bf8cd47f27118ef7743cdf0734310"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "8a96d4899f06ea4b24487887654cd9cc6d48a21d4d91062b49da568ca7ebfae4"
    sha256 arm64_sequoia: "b05946d6b962bb5105849b6eefb5ec13d5d96dd93ec8770f76a0b58972ea3171"
    sha256 arm64_sonoma:  "1683578ed1cd586fc93508e82fcc2ad452084c63ca9fc78c6e7f115c7e1a70da"
    sha256 sonoma:        "dc132bf39dfd55e73afd352ef30e12e37cef0ee70c2c1e542db40aea31f8d7ae"
    sha256 arm64_linux:   "6686202e38b77e94f283bf1e22831026446c59b97ac43f36bce27ae828272da3"
    sha256 x86_64_linux:  "122e9f13ae62fb754626a2ed8a3b28764073d8e3edfdde07a1fcf193bddf26d3"
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
