class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "3acd6759e4c6c39c8c194e2943366ce930a554b688d2e6f057e12b45f4a9fbcc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "415565e83c464f718cbf2d1a8a8bdcaa0ec30254f28224e4456fb0257a92a9cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "275ce933d1ac2a62e81e8c44f7e5a0591bb7fd280098513f7ff4056e74d98fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70da31392294a5269af86e32f9cb9e4d796a55480ee5a39107675c821144df1c"
    sha256 cellar: :any,                 arm64_linux:       "11934f305377a5e590f2379d7bc5af1588cfdd8e7dd6b82a197561aff5bb3111"
    sha256 cellar: :any,                 x86_64_linux:      "ecfb037455f7be3f3a59e19f61cd4fd78e8f3a62c388274a37a3f16d7da67807"
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
    pid = spawn bin/"diffle", "working", "--port", port.to_s, "--no-open", "--no-lsp", "--no-watch", "--keep-alive"
    begin
      sleep 5
      assert_match "<html", shell_output("curl -s http://127.0.0.1:#{port}/")
      assert_match "+world", shell_output("curl -s http://127.0.0.1:#{port}/api/patch")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
