class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "3c2d4abab0f381b7dab64dc04a7a1b834869c294cf6ce74f3dee50a34b4d541d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f32a2bc0bc0a1c63a0f496719c2ed4da225e76fa0d23131907865a20d0e87933"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30f4838e1688b70821e9df86f64c2360e8863182c859885fa15e20b456783d54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8208bd9db040a956e07405bf8f074d5c23812c0e4404aad2d297efef3e04f40e"
    sha256 cellar: :any,                 arm64_linux:       "e844369e0b68863af7d497bb36d22c32dfeb87f0b5c1d7f4905d1f5292ce5983"
    sha256 cellar: :any,                 x86_64_linux:      "7fde6bc824117644627f0fff09b8f994443cc136dc537d6f6bbb91d065c1f455"
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
