class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.95.tar.gz"
  sha256 "d1b2112ef7b3441ddb2c4c5b75443c257ca08ed8b42d26343b6a485a007a8e4c"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "708594a545cee4732817e7e1fe416c6191055113cc1cfc6b5a49a7efcd4d5f48"
    sha256 arm64_sequoia: "8bc9b0b44d8a68cb801523058dd7d7710ea33a46959d45bc1798caea27ac1f77"
    sha256 arm64_sonoma:  "0b611aad0795ea8e335bb4f3f6e5f6f291c37d23fa802443938b8a81e3e01434"
    sha256 sonoma:        "a20ce976f00f22eef3918a0fb3d8fbb4454626ea4120060bbdbb66af4d736a5a"
    sha256 arm64_linux:   "2332e9cb990d32d738ec1e2313670d62e84b5b690de5323438a1cbb80722079c"
    sha256 x86_64_linux:  "a29c947d3126477cd3291be287df1206f68d7f072c30bab7486a710099d3c7e0"
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
    PTY.spawn(bin/"cliproxyapi", "-antigravity-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
