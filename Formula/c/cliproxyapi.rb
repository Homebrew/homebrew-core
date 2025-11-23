class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.9.tar.gz"
  sha256 "81ad38cfb893822b861435ffa528f215f429c48a100e3fe1df107e3479c0c83e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "685d4aab079bf1ac172dc5c1a533bffc055e512379af26f6929dea5c95129d9e"
    sha256                               arm64_sequoia: "685d4aab079bf1ac172dc5c1a533bffc055e512379af26f6929dea5c95129d9e"
    sha256                               arm64_sonoma:  "685d4aab079bf1ac172dc5c1a533bffc055e512379af26f6929dea5c95129d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "087c0473b6ae037fc786c5e400474cf73f4bb1771905e32dcd9d23ff7e511337"
    sha256                               arm64_linux:   "4e75056d55c4f64df80d0c79a11436d24f4231850a85eea79b3bcc2fa8115c30"
    sha256                               x86_64_linux:  "aa259b422ca6a690024dbe95dbbb415c6227c44d81106847fc721a9bff83b15b"
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
