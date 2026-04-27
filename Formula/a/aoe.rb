class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "9d964f728792ac0b484d06172e6c3aa609e805954bc6e65c7b38c9532cc6d849"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6e6799d1ddd07dacb27e3ed9acab4d502f5e6567ad1cd0ccfa0b112ba9b2f68f"
    sha256 cellar: :any,                 arm64_sequoia: "259c0777e6c38efacbbe75c60fda3f3a0f411a201a01f06edeb095fb43fbea80"
    sha256 cellar: :any,                 arm64_sonoma:  "99b42796b4e1e26a6a676a8ba9c66f73f6bf7ceb71ac83aebf28ea7e7b2cee3a"
    sha256 cellar: :any,                 sonoma:        "07f6a21388a7c87b57c6d9794cf857ebc0523205521660f23e24a6e188073a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c01bf6bfbb130de348cc61ff3244742b40da3ef916ff0e93ee4778d300fa2ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec737362747304e635c1b103fe9cb3e751a3193511042d8f72af7e795c518e0"
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
