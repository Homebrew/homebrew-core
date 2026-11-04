class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.55.tar.gz"
  sha256 "9f3d32222d6be0eaec77d262b68848dcec9e409fbfd6ff23671055a1f9e8848f"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "4ff88eeb92b6b974b24837c2226861e91ffe100246d902881ea3f893cd280ea6"
    sha256 arm64_tahoe:       "ee2010521edb07617c8209f7d031a4359957b293fda2d647c9e6d0d4817030b9"
    sha256 arm64_sequoia:     "e2c37c5f4dd7173e4b052311cc0d33b12458ade6b8ecefb02a109f28197a13d8"
    sha256 arm64_linux:       "920a1d0cce3c8dc7d198c79646684e08f01387ede2ad6bf372e2b25a7af19579"
    sha256 x86_64_linux:      "29b84e42a8aa8aba55308ab1b8aa7a48f2343e122e1d9401b5b4ef0d5e402292"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
