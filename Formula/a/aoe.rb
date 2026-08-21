class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "6c24f7f537954b264048f514b5c74227162019ec8b514008883fc296ff71bc38"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2202dea2adb14328d4cd6fbd454fbf60f59f1f3ddff52b5cbaf46dba0b616bfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec4baaa14114e1a5d9f017671b448140e8eb4f074e85dde2846ba3d3e5e1e26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b38c17266c476c5c5888979d3b486dde180b0fa581bc3fa3a3b979d257b228b"
    sha256 cellar: :any_skip_relocation, sonoma:        "96ec4cb4fda49ca8872f68d59ac502ad5da995464e324bca1ba18fc8c307356c"
    sha256 cellar: :any,                 arm64_linux:   "f1f44164f10d7378b3b6596b9c78e62a77fbc5524efaf93cd8c2fa478c311d28"
    sha256 cellar: :any,                 x86_64_linux:  "c4e93619a3ae8e7f0cf9af5ecc5a22f0530aa7103df45837ef991e28c04ba6f4"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "serve")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = fork do
      exec bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    end
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
