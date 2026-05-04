class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "cdf109969f5503d0d217da62836b0619afb72e0ba2896c10f1d0c455645c8b20"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "daf7932f9d9b05456dc2afe1550f553f34d26ca64f25057884937a29e6a0d3ba"
    sha256 cellar: :any,                 arm64_sequoia: "7ac860e4f4869fd3852258b2aa9f0e06a976aaa36d863c405c279e4252ccb7d5"
    sha256 cellar: :any,                 arm64_sonoma:  "d6a92c028eff869dcb8f8a88d75cda72ef4bbd00d4ba38a42810f946544a5291"
    sha256 cellar: :any,                 sonoma:        "9f121b915964ec3a394aaa8ec488bb4c6b653642b515b2c819a467bd84640b93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "449906703abd9a4b17e94e46d6edf7924f19ddbdcf8b4ebd2896830487f27484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50689cb08c3b4772b932755af2a351d593d683a12578cf73338dd6e653f21975"
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
