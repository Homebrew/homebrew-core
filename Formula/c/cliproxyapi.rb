class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.135.tar.gz"
  sha256 "2881c4337a959e1b313aa4527c2dce17f8dc89a7d8ede7b33023c09bdd414bab"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "cec4c6f9938dbba3da3a703661c44e33c8796fec6a5e192640f9c3c49aa44be1"
    sha256 arm64_sequoia: "3316b2d2701c9368770ad31c9efc5c24c8f7235caf3d5c62a8afa4dd35820f1c"
    sha256 arm64_sonoma:  "215aa3310cb4932d1557742abc194d93d069a62dee015b8f8af54b59a57cc0b2"
    sha256 sonoma:        "f01be2b8b613dbcb8912e2dd8b4158190963b31df75c92c3b282ab84b3ed9a6c"
    sha256 arm64_linux:   "35806d69acfbc1dfe359612a59b1c9bcc1db13122c5f44d87764e7b05198e0a8"
    sha256 x86_64_linux:  "650f61b39f3898c540a9d56a74b4807b33940ce956eda9b5d1a3bd4f83bc46db"
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
