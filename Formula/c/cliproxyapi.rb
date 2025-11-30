class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.29-plus.tar.gz"
  version "6.5.29-plus"
  sha256 "97f52fd270d918c071256973c4288f10c31e3ab96a2317031b75d9d591e5fd01"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cdf35b571112c29acb5916f4d1feac1b296ca6dec0d6b5287ddd8d8ea1da3366"
    sha256                               arm64_sequoia: "cdf35b571112c29acb5916f4d1feac1b296ca6dec0d6b5287ddd8d8ea1da3366"
    sha256                               arm64_sonoma:  "cdf35b571112c29acb5916f4d1feac1b296ca6dec0d6b5287ddd8d8ea1da3366"
    sha256 cellar: :any_skip_relocation, sonoma:        "279cf36741ba647dadc81546f711d7981cc2c99a9edbaff330be84bf6698d3e4"
    sha256                               arm64_linux:   "44aa70091441ee18396457e8b30583f72aa659f5d6ed339fd4c5c3b0e51d4df7"
    sha256                               x86_64_linux:  "9237f05e3ec28ab6d692ec48574c8b016cca0972afd6e7e025187539c57200ac"
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
