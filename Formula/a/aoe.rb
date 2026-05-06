class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "cdf109969f5503d0d217da62836b0619afb72e0ba2896c10f1d0c455645c8b20"
  license "MIT"
  revision 1
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bea7b5a34a6b0b365ba326b275f39ab95b20567a3fb62991b6b45d453634076f"
    sha256 cellar: :any,                 arm64_sequoia: "30987cf4081079a41f7193426cf07c1567fb3d913a09cfc73ca6262a7509b44d"
    sha256 cellar: :any,                 arm64_sonoma:  "e3d83bcf23364136c9b1e0d4169396d18c1559f4b2599d9ef36a10489375170f"
    sha256 cellar: :any,                 sonoma:        "86e9bffd573645cad677338743cc0822ef391fe972910bcd991adfd7904d7aeb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9566c7c84460a70694ccc0ea464b0acfcefead51cd0ba0afba1d565a7712d36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5f3547d10ae148528f313a0f6720877f4f7c6fc8b24c6f39d38cdd364078fa"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    openssl = Formula["openssl@4"]
    ENV["OPENSSL_DIR"] = openssl.opt_prefix
    ENV["OPENSSL_LIB_DIR"] = openssl.opt_lib
    ENV["OPENSSL_INCLUDE_DIR"] = openssl.opt_include
    ENV.prepend_path "PKG_CONFIG_PATH", openssl.opt_lib/"pkgconfig"

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
