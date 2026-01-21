class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.7.15.tar.gz"
  sha256 "8a2a492cbeb055732aff58c26ae846638b0d6d5616302118ea9cd8ec9d73e6ad"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "6d3aab942fadd3b4a01b59a6a768e33713c8b64b23186ace61ec667dea916247"
    sha256                               arm64_sequoia: "6d3aab942fadd3b4a01b59a6a768e33713c8b64b23186ace61ec667dea916247"
    sha256                               arm64_sonoma:  "6d3aab942fadd3b4a01b59a6a768e33713c8b64b23186ace61ec667dea916247"
    sha256 cellar: :any_skip_relocation, sonoma:        "33452a9b7a0b742c2ee39fdbe1704ae5a5b530e2e39a7cff7daaf7083f03b6e8"
    sha256                               arm64_linux:   "9521a0d137f82fd92a274a469e982685cf9579609efe0ca9bce3c141b961cb53"
    sha256                               x86_64_linux:  "ef498ab7546a132d468c6bcf00f407dc4ee47af737070673f15b0e07502c561d"
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
