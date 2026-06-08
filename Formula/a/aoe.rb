class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "4a910c2b051793926191f214c005e1f66054987785a9f37bae3265d6a40e3a45"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7deeb13d1a36aa7ec63c35cdbac424db40daa6755736ac218fd889b652eed267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4502f9cb2932f844705c0e748c287d07bc7aad6ea5532591435ae91388270d18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "530bd5570f6822916471bc0037f0d103851445449b21a830769a61ed11ffbfd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d99d55f7dd9c41b22716c97dce93592bea858290fde3e98f2f17a285a5e7738"
    sha256 cellar: :any,                 arm64_linux:   "92e523d8f2805e48729ec9df67c8657a5634c9a964e7b152a60dc4a416a6e26c"
    sha256 cellar: :any,                 x86_64_linux:  "d16a84669098f66e1c82703a508cc5b11353fc676df14da8fc6fecd55de91ea3"
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
