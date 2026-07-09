class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v7.2.50.tar.gz"
  sha256 "a4ef34b7f521fe08e1395f11c3e9b2772bbdc51cee3500323dc9dcd91803ce42"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "8767b970747fd8ff2410ddda472defdf4732a9253dc927ef02b6362599d3c4ac"
    sha256 arm64_sequoia: "312e1c8cbba900387db56daa43fb1b3ccb77e6ab4ba3fed844d4aa5360ae1e84"
    sha256 arm64_sonoma:  "9e736204ee88112fcde76d08a223dd489bb2eaf099e0b35f1f94988c3e42293d"
    sha256 sonoma:        "50abddbb7f06d63a2ba7b6a4e4d4b1eafc89a03a0b9cb0bb37d294089b1e9722"
    sha256 arm64_linux:   "f88f96c5ab14a0fefbfda88a2a4f8f0aa08aa01276e1c00cbc586fd7c959f382"
    sha256 x86_64_linux:  "d3969bd6ffb5ae7d3631f318edc6167542219f5c37e8d78e809b7a6e7d06dba6"
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
