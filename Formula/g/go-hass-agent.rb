class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.17.0.tar.gz"
  sha256 "8506161fb719b948ab026c2533bd43b03659d0ac490f6b343fa2b4591f62696c"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5128833fce0828d5cbc93305fa1a0f2ad7bdeae53f964c5365cac1ad71c6727"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ece9ee65d6cc099b16cb94c9ec356a1607540e6afe43682b862b99680c4303bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b01a0b14d3e2a82b46fd2be341ea99d1982f8aaea6a4a2e18bf4ab15aac576f"
    sha256 cellar: :any,                 arm64_linux:       "6e937a25faeccc96294058739fc1f68d4737bc73d2a060f3dd678943132f361d"
    sha256 cellar: :any,                 x86_64_linux:      "4ccf5d77119709d559411af18118b0c5d352b49098849dc4168d5af59b200502"
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
