class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "3e8580fdcd07e940c219a2b6c76c57e0368eb6e409550e313b48154f67b59a21"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c816beb7ea7f145f143f65299b447a589567fcb84da847d463b363a9ff42457"
    sha256 cellar: :any, arm64_tahoe:       "180cb8eb6bb5238360c4a73c92178c66b838b507239f37c693ba65e8e62de48a"
    sha256 cellar: :any, arm64_sequoia:     "f5450d4d40e01dbf54e2809730b127a178786da5a65cf4278071051f2e1ba84f"
    sha256 cellar: :any, arm64_linux:       "d940b1435a5fa1ed1492d6e3765a341b552356d77bda1bf735be9044ac667461"
    sha256 cellar: :any, x86_64_linux:      "69cbecc225c4216fcb90c4d7ba90aa0ea001d464ef4a2c5b34447b31427de0c3"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"
  depends_on "tmux" => :no_linkage

  uses_from_macos "sqlite", since: :tahoe # requires sqlite3_set_clientdata

  on_linux do
    depends_on "aws-lc" # cannot use on macOS due to openssl symbol conflict
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "web" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
  end

  allow_network_access! :test

  def fetch
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1" if OS.linux?
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args(features: "web")
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    # Keep the tmux socket out of the shared `/tmp`, where the sandbox blocks connecting to stale ones
    ENV["TMUX_TMPDIR"] = testpath

    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]

    port = free_port
    pid = spawn bin/"aoe", "serve", "--port", port.to_s, "--no-auth"
    sleep 2
    assert_match "Agent of Empires", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
    Process.wait(pid) if pid
  end
end
