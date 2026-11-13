class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "fdf4619d0b138b74ad1a32c31701de8c8d144d3d1130aba07f7e859e00973237"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9629536b6857e4615afda2554793ac0b620047ac819a7a0d3c261295c37e7e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2113d23ec2a1a7262a0112b012adf6fc5f3b77d4cfd344ecb85b8d10b78bd0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "282d003b7413371e6650fa7bdef29d5f4396c1f388cbadc5de116cd92ebf26b2"
    sha256 cellar: :any,                 arm64_linux:       "14d9a449ba3cf3e61125e83160d9898e6154018b55c3616a664872d4bf76c930"
    sha256 cellar: :any,                 x86_64_linux:      "2862dad0f2a76b949c9103a21052ff885619e16d101e09a13e095fdec9ec41ea"
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
