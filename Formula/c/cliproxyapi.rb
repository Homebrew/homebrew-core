class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.1.15.tar.gz"
  sha256 "ce396035065abc4896b045631c942eed78ced92806095df3a93f38d0c3cd448a"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "5ee287327bbd6c7c4009fea42bf5fefc484669a4e393d6873205e4c531fdef06"
    sha256 arm64_sequoia: "5ee287327bbd6c7c4009fea42bf5fefc484669a4e393d6873205e4c531fdef06"
    sha256 arm64_sonoma:  "5ee287327bbd6c7c4009fea42bf5fefc484669a4e393d6873205e4c531fdef06"
    sha256 sonoma:        "2d156a3507f3b7a7efde0a94bc79549998d58f81984ec8e3dc152353542b93af"
    sha256 arm64_linux:   "536372f0b2f73146b9dbfb0334059dd817c82b518ddf5e2c1bf5d6c84f1e14ef"
    sha256 x86_64_linux:  "d693b482d0aa90b23eef1bb9db31a76ed0c7be4c45b7a6b9128d0a85416dd373"
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
