class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "125e877f6f2ec52090fc0c62e989a2eb18495d61530a4f386b4ee8600d570e80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c13373cb036408d40dab3507f68feb6fe55f6fa3202378ed2af4e09d93b7e8c7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "560a76a9e61442813c167d63b8c1f2b2a7253b51223ddf37a5ab7cb1c873642c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d6f39eb3cdd74131ef9932eedee93b1e3495cf5ca103c077d6283fa3b0524e1"
    sha256 cellar: :any,                 arm64_linux:       "e3a65a047656e0f5e40bd42a1c5c4a5ce35910e92435d7ef18cb8183bcb4b394"
    sha256 cellar: :any,                 x86_64_linux:      "7e9e654599085aeb4f66181f741688f171a293be2b66c9211e437754f3cab944"
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
