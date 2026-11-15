class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.19.0.tar.gz"
  sha256 "43eac861d8e8765dfacc803e64ac3b73c8b5ef74683c621e4ab08283e0df99aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf0298d5c0a7d2d13cf799b80db3141146bab25aef5e303b131df91041ace23c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c45fd2e28fe3a53fc9d5e84769ca40a8dab16cd3797661ace913b8425ba6300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2f4e108904abff277ab95fec8d6a01f5e4fcedf49cca5547bee005f9592730b"
    sha256 cellar: :any,                 arm64_linux:       "27a070f1a2024376e2460cb5cae17b98216c0ac437500a5ec3f00c10c3528ec9"
    sha256 cellar: :any,                 x86_64_linux:      "582b42fb0d09a25ab35717f57e8672095befb7d485a66e3d29f3bcfa5540a4c1"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build:js"
    system "npm", "run", "build:css"
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
