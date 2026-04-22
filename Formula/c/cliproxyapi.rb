class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.9.30.tar.gz"
  sha256 "0765296ed95b10d7bda76e41290dfcf97240a91f432d6c93dac7c48c294d9aa0"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "43347b6fb9ac4468b9d160dc24f0cdea600ec74f51ef94cd747f773739877e8c"
    sha256 arm64_sequoia: "43347b6fb9ac4468b9d160dc24f0cdea600ec74f51ef94cd747f773739877e8c"
    sha256 arm64_sonoma:  "43347b6fb9ac4468b9d160dc24f0cdea600ec74f51ef94cd747f773739877e8c"
    sha256 sonoma:        "a0ce131d2deee41fb8f3fe113e6f1a5b49e7b1aa2696658573eacff5827511a9"
    sha256 arm64_linux:   "dcd6a0f10a76d56dd8f52cff6abb5caca1e6b792f7d755238ce7ee5d32ad7f8c"
    sha256 x86_64_linux:  "9afe3b5c8c6f01bc22bc8801db3b23ac1c408fb6f465975f5bf2a7cead2cef88"
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
