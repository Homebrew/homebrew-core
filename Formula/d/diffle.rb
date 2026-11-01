class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "125e877f6f2ec52090fc0c62e989a2eb18495d61530a4f386b4ee8600d570e80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4eebf98f3de8848ea38186fa81af46fb49a6718cf223f50e48c9012d4c2c9929"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbe8275e0b9fdd139b0f3717680ffe7d931d724b68d0a72c83fd69e8997da201"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "200e0fe924728e49ef79934290b9e73064ac3d5e8ac193c29e972289e45f6ef0"
    sha256 cellar: :any,                 arm64_linux:       "03694b05dec61066d3f189e2feb616e98946608fb8d3368dea1cea0ff2e6a78d"
    sha256 cellar: :any,                 x86_64_linux:      "4e9c1526746db39b8799866b29b24b0401b7a5ab33c2510c68929c6a173f2990"
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
