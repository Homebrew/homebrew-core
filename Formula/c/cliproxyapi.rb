class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v8.1.2.tar.gz"
  sha256 "fa3a8f9b6d23d7a77bc8e0567b13f281a7d25c4b6a98a12394696be08c9bfabf"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    throttle days: 1
  end

  bottle do
    manifest_sha256 "d1c12113d10bdf92d87579f7ff62a2cf19f9bdbfb3857e7bf3b0580a52cff7d3"
    sha256 arm64_golden_gate: "a035dbcf13663d24d29bc3db6ab92a4d58dda5201aad9b6aa602e362067053e8"
    sha256 arm64_tahoe:       "23b7146f37417e682ebe9a051c842c301444a2c53bb66d981e5c14716480e824"
    sha256 arm64_sequoia:     "64f24cdb0837556e8823ea39d50cf4581fbaba9f386102fa3d8e56a0c13ef443"
    sha256 arm64_linux:       "1f34e7d5e3ce87b4b63e5ac796c51be504b1cec8ecaefc45d2e713e092315ad0"
    sha256 x86_64_linux:      "b5ebad7b6c2de59ca633cc85d7b25798a0a16455a7e372a047f2abbe43377b5b"
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
