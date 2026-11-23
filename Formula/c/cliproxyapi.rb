class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.1.tar.gz"
  sha256 "bb3813e38010e96a6cc717008241ea169bb74c1f00c53d7e191bd1cbed144571"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "9c28494f4d40ef08fc3fd65010ba2b569ab176471bf1d301c138fb91e3e178f1"
    sha256 arm64_golden_gate: "ba435c12542514641971719ea5b0ce420992a8fabab0a10476ef005f03a4a380"
    sha256 arm64_tahoe:       "ad8cfd22d1701328401489530a710d93dcb211ee5289ac85d40bee930fec8d3d"
    sha256 arm64_sequoia:     "4cf4e669b685e4229bd4ae44405087e81827dae4a84493f0d0b4047cd4a26ade"
    sha256 arm64_linux:       "1948ea8df63919308c5b1ad9a18ef05b3741dc25839b8c1fa5805b427694ffa3"
    sha256 x86_64_linux:      "3c1d2cde52402ce5a286a4852fd27a175063755609fd45574fb6ba2112a8f7f9"
  end

  depends_on "go" => :build

  # `test do` block needs local sockets for the login flow
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc}/cliproxyapi.conf
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
