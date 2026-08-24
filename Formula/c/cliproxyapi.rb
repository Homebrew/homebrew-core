class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.140.tar.gz"
  sha256 "9cbb3ef2861a4edcfd23c329f8abac3dbcb88ca5a5ce9110ea97e02214cd555f"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "4197867d6b12e2853fb69472afad1895aec6ac067272bdb7537280d7a815a762"
    sha256 arm64_sequoia: "e0bd70cf4975a31b063d4ae44c0b83e1ef62a5265ee087ff818d8880601cf8ac"
    sha256 arm64_sonoma:  "df3bea51ac09631778aa038782a26f9c1a7a80ba9248020d19e6a91f818b77ad"
    sha256 sonoma:        "32eece043449bfdfb057bf2179c266906bfd211d15f109924d495b73d82f6988"
    sha256 arm64_linux:   "44180c8dac18ee839fa304599bb843ff58e3a13e7df608b686b20c50dcadb8e2"
    sha256 x86_64_linux:  "e889b8bfae25b42643e9a8b11602a00d2ca9e3d0b26e9da72208a290307b522c"
  end

  depends_on "go" => :build

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
