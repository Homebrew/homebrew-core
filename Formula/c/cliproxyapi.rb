class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.25.tar.gz"
  sha256 "04225ca081dc222aab40e011d76e39e093d1f665c1a24171baebaf3d4c8e09c8"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "e47103311fcfa9b47e37efac3d7d5d1c19beeee1892d0e57f489270f4c0d7dea"
    sha256 arm64_sequoia: "207af6b5042de987a0e974933893c4f65c698d6e226faf22042d9a47431416c7"
    sha256 arm64_sonoma:  "ed46b64135d8d50b259b7baf40e1c394b77a442b3e8aa4318396a1df78e83e18"
    sha256 sonoma:        "5006b79353c3cc9d6abd3654ea42105de70b3cd80e032eaf6b74f122ce9d6673"
    sha256 arm64_linux:   "d9771f7157ea619ee3b507a67e062f6a5101b70877ccb5f456093ec00c4e3dab"
    sha256 x86_64_linux:  "0c1c8740e61a9f8958f1ceebd74da4e6053c9ef7d05c5dd5f793f542bb930471"
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
