class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.47.tar.gz"
  sha256 "7065f568762e195d48f6eb7148a62d2cd1173eba2673cbe3e7f55bc3c2136d92"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "52942ee92a8b654aea4c2f4272afc58b07fe01b47ca4a8e19b1cda5dc23cb665"
    sha256                               arm64_sequoia: "52942ee92a8b654aea4c2f4272afc58b07fe01b47ca4a8e19b1cda5dc23cb665"
    sha256                               arm64_sonoma:  "52942ee92a8b654aea4c2f4272afc58b07fe01b47ca4a8e19b1cda5dc23cb665"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3d3f2c138d43f6c313e89941f89ceae2e30c449a90844dc8980d3c2ce3625a3"
    sha256                               arm64_linux:   "e846842e9b58e21640fe34b877fb877cd86de84656f1b99ed872582af3dc951b"
    sha256                               x86_64_linux:  "8726416985c6758c37b8b2d27a0b25b54c511fae1ef70bc5b6be12b31a9e1e1f"
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
