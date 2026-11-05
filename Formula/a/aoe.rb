class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/agent-of-empires/agent-of-empires"
  url "https://github.com/agent-of-empires/agent-of-empires/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "1a4b12639345be414623fad37fb3b8a3f0fc38be11776abc3120789d1fed52b4"
  license "MIT"
  head "https://github.com/agent-of-empires/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5fc8224003918129336956cd447ce63cfd39e471bdec86b4b9b85c8f517f71dc"
    sha256 cellar: :any, arm64_tahoe:       "af214d64a08f27620bb198e79cf7df6f18b28e1e1a73589e5c51cadd5998fcf9"
    sha256 cellar: :any, arm64_sequoia:     "c210b1d8c2bbcbf12fa715f0d07281522070118957e06361659decf0a5f1dac8"
    sha256 cellar: :any, arm64_linux:       "24d25ed8e5a4ceee727d429a3992d81c4d8953856d224890a3079035ec200af8"
    sha256 cellar: :any, x86_64_linux:      "7d9f324b01817b0ac83e6964927a625bd6821fa9808a9fb64b39066342413652"
  end

  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@4"
  depends_on "tmux" => :no_linkage

  uses_from_macos "sqlite"

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
