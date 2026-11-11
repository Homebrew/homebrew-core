class Diffle < Formula
  desc "Keyboard-first diff viewer with LSP support and GitHub integration"
  homepage "https://github.com/moritzwilksch/diffle"
  url "https://github.com/moritzwilksch/diffle/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "eb847846edb3909558da5b9e259cb60c4585e1164e11931006237882fe267b9e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15155dd614bfb730cbe4f6109e8e4a8a8a042f30e45c750cf2f5a05869080a17"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc7c3688136e54e95d280beb344c44db25c941ac84e7aac934a45078d2af1ea8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ed57eb6154453d1e24dd8cb0ea587b70849c171350126cf1716be3e89edeeb4"
    sha256 cellar: :any,                 arm64_linux:       "fd111f5b3d2c7c528322403f59646a5948162259c92d1621d5cfc1681464ed67"
    sha256 cellar: :any,                 x86_64_linux:      "c865e2a77adfaec301749ff07fd9285ef06063477223462ba994269335ef69af"
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
