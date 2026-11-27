class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "01dcf92b3dee3011ec926d8ff21389e8aea9d3f472f633cc2c0236c4ad595009"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "829c02f3d03e3b3b92440ec3d5f9aa80d6a3236b3c64f2a08001d236ccaae0ef"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb59899ea69e13b1cc2973184fb07dc21e62fac28f9081af6c6f3e8a805ed9ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a735daf08b1abf0df703f2b27e1371ae10855b79927ea70e803a8c99561b49a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c95a324fcc23e2e1bc2814b94b9accb6ed688f62ce51c099cd402dc06f906e64"
    sha256 cellar: :any,                 arm64_linux:       "c15fb3cb9d49d39ebe5ad41495cbb62ffdfa8b08afef4be6bd84ca30cc0864cf"
    sha256 cellar: :any,                 x86_64_linux:      "72bf7e70d469f817bf3efb8e15fe53e799a5dd5df221ddbbe3e7be252a303bf7"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "npm", "ci", "--ignore-scripts", *std_npm_args(prefix: false)
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "npm", "run", "build"
    system "cargo", "install", *std_cargo_args(path: "crates/diffle")

    generate_completions_from_executable(bin/"diffle", "completion", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffle --version")

    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    (testpath/"hello.txt").write "hello\n"
    system "git", "add", "hello.txt"
    system "git", "commit", "-m", "initial"
    (testpath/"hello.txt").append_lines "world"

    port = free_port
    args = ["--port", port.to_s, "--no-open", "--no-lsp", "--no-watch", "--keep-alive"]
    with_test_process(bin/"diffle", "working", *args) do
      sleep 5
      assert_match "<html", shell_output("curl -s http://127.0.0.1:#{port}/")
      assert_match "+world", shell_output("curl -s http://127.0.0.1:#{port}/api/patch")
    end
  end
end
