class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.60.tar.gz"
  sha256 "f99d6bd2fc90b9931699ea17340bf36fa9d7291d238b3d2b94d0229903c7552a"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "b57f02ac91fbba923ce77ad978bb3a40fc71a05780bba05876db8e28e8282562"
    sha256 arm64_sequoia: "1276cd37edc81a0cbeac4513d61401e6573c2b236ed917632556a734e3434dfa"
    sha256 arm64_sonoma:  "26a6126b2281ed27c5da014dacd735e5222eb477ccfcf35ee35eb02762f72754"
    sha256 sonoma:        "0cab0342b14548c6cf6cfa88277170a51437d26c2a5bb2735302f81a4bcd4906"
    sha256 arm64_linux:   "bf961e82fafdbea2634d24b30abd919048eccb0c60e7a68c08f09006a94cb5f0"
    sha256 x86_64_linux:  "6e723984201d52ae621e3fd108dbf4cec0f6c0c11a153da752d61262c582d7c5"
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
