class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.0.53.tar.gz"
  sha256 "0b51b2a9d6c7ad2220effca65d9c435a0379111ab27a1bf84d7f245bc9d34809"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    sha256 arm64_golden_gate: "67b0b41a100fda3f4ad37896339f19e92e156736818a1bc22c4f3a4cada4fed7"
    sha256 arm64_tahoe:       "a33ac5e7958761e9ad6cd8a287cccc510fbf11d2e449c938fd1fd9a583ffa522"
    sha256 arm64_sequoia:     "4bfe2fdd2c2fd044ecbf822d14e84f6f54633c67162b4cad8540831bae7cca61"
    sha256 arm64_linux:       "68147be58d81d80a67e25717c5c16a8e87593c8264c01b1326e9aaf4507bda74"
    sha256 x86_64_linux:      "96891ea9602a0fa46b0707f792ef4e6f8344bbacf80b57545d3e414774e84883"
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
