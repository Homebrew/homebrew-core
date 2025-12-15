class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.13.tar.gz"
  sha256 "04219cdd72e6de78cc3338dc032f74e79bf7b115d78de7497c017e36ec3b4a32"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d8189bbf55410591fc5a2b19397da7808293466f60c0430b5229a0ed6a565ca2"
    sha256                               arm64_sequoia: "d8189bbf55410591fc5a2b19397da7808293466f60c0430b5229a0ed6a565ca2"
    sha256                               arm64_sonoma:  "d8189bbf55410591fc5a2b19397da7808293466f60c0430b5229a0ed6a565ca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33e47370032de353b34cb03b1e575e5138f87dccd96e8a6f3f0c71e17bb10b9"
    sha256                               arm64_linux:   "1de6fcf55a9c0bdabdca73a31af71bc62e937b825d89fe868cd817aaef68d6bd"
    sha256                               x86_64_linux:  "84785be6cf65716acc2c631a3db881fc66131592cfece3e5cc2222499aa7108a"
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
