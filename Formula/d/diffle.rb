class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "602ad9a1f58fb3d3f730095e0dd8ada2a1f40ec6a1ccd9d835b3242db104bb2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07f49f93eb19b2a6bf9f866f20e7d4f0b59997f04a0ac2b89e5b7995541cc106"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "338ad2a2c282382537e047b0e5734a62b1344644d31cf85a2c89505a170d1a6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "178f18fc3f94634e7d915b40a09a13b23621f92ae4581b8f38556f3c37fd14dc"
    sha256 cellar: :any,                 arm64_linux:       "c7324b5d18afa4cab73f7f5998b6d1686a4a5b6a10f2b97cce1ad0cb2d7058a9"
    sha256 cellar: :any,                 x86_64_linux:      "24a51ebac55918380034cda2ac2b6a09b44d4bbf65532198e109e5b14a992a22"
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
