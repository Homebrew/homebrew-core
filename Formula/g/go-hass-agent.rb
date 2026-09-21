class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.16.0.tar.gz"
  sha256 "fda272a47b201923beaaaf446ed10a185f26b0baa1fc869e7ac8577b3e12e65b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "91eedbdc94bb4c17e1885bfc64d8cd81c3af6def8ef3219d7ff64c341cda1ff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "27da3ea180264d7b19be1f8ee47162fed8f2b73784b2c58c6855ce6c66da914c"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on :linux

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build:js"
    system "npm", "run", "build:css"
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[-X github.com/joshuar/go-hass-agent/config.AppVersion=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"go-hass-agent")
  end

  service do
    run [opt_bin/"go-hass-agent", "run"]
    keep_alive true
    working_dir var
    log_path var/"log/go-hass-agent.log"
    error_log_path var/"log/go-hass-agent.log"
  end

  test do
    # test UI load, primarily
    port = free_port
    hostname = "127.0.0.1"
    addr = "http://#{hostname}:#{port}"
    pid = spawn bin/"go-hass-agent", "run", "--server-port=#{port}", "--server-hostname=#{hostname}"
    sleep 3
    assert_match "Register", shell_output("curl #{addr}/register")
  ensure
    Process.kill("TERM", pid)
  end
end
