class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.40.tar.gz"
  sha256 "f0d190086e57f59a6f81b30ca64823e675dccf9fd163a4ae928161473ef92280"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "68a51c6f026811184489db5d8ba094b3d59aadbfe0f16f824b224d9b9c27a55a"
    sha256 arm64_sequoia: "0456dd5b7fbc5f9ea568233adbfadb87013b6b2914e5811d4a09c18c9834b79b"
    sha256 arm64_sonoma:  "3e2a86f5db6f83c9d502636407ed51335cd4fafac66ce436bd79090e9a2c5d4c"
    sha256 sonoma:        "49d61d38bf884ae4e6de17f6c5b80e89dcdcea3eed08b3d9342c045b7a329557"
    sha256 arm64_linux:   "0299f901c21041df4b28c15b73bb5d6d922e2524d3ae9c637bfc8e07c5ac59bf"
    sha256 x86_64_linux:  "c2a64abd27d1dfd17851041d66e815efe6382e8eb11c02f64acbc16e9d70c2cb"
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
