class GoHassAgent < Formula
  desc "Native Home Assistant agent for desktop/laptop devices"
  homepage "https://github.com/joshuar/go-hass-agent"
  url "https://github.com/joshuar/go-hass-agent/archive/refs/tags/v14.19.0.tar.gz"
  sha256 "43eac861d8e8765dfacc803e64ac3b73c8b5ef74683c621e4ab08283e0df99aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60d413fe25d39cb1049873aebdd11344ee6c994e3e1d879e253f397ab788c043"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3cc2252527e1800e8b34b66af7f44a30a1f740de7e18809256115a0ce55e63b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "40c61dd0a09b29014e19fd06850dd29df99a368378157f128d57af7d4d562dc0"
    sha256 cellar: :any,                 arm64_linux:       "df0a84a83f5b3b54b3c51071019b0e59488021c0369aa22d77eca9c1e5200ceb"
    sha256 cellar: :any,                 x86_64_linux:      "f4a5e4a33bb0222e8935bc39d8b122975c37bbd86e01f015368c7eb8e7edbfbc"
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
