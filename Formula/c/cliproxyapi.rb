class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.0.5.tar.gz"
  sha256 "4834c57fc95810deeb9ed9b3a52307d6fbd1aa72050130487ef602c307fe3d86"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "0831201060db818f210faea7081d5f1434ba13d3f6605ba1296d8ae1648bfa1c"
    sha256 arm64_sequoia: "0831201060db818f210faea7081d5f1434ba13d3f6605ba1296d8ae1648bfa1c"
    sha256 arm64_sonoma:  "0831201060db818f210faea7081d5f1434ba13d3f6605ba1296d8ae1648bfa1c"
    sha256 sonoma:        "168f0f8bc4cd81248dfb16b20a9c846eb5aa715af2100b16df36ac1fa221f9be"
    sha256 arm64_linux:   "04b6d846e28cb8955da3835b86a564cb27398cfab4dd7fd546115ad6f82ed28c"
    sha256 x86_64_linux:  "2d0c5a816a2a486a1800befaa2e71d2ce874d95c9b9cd42b12d205818bf3d059"
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
