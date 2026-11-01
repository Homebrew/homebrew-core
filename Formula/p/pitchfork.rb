class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "bf5116a058ad39364b96ab80598c86d1061415d192f7be18af34f37b501a7857"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d9a3adfbee7edf2baffa6af8df4a0b6d213a28c82b7bb0e9bdd7e39fec3c090"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14e0dbeafa9b79fc004629f80712e035796e5954d757ac8f993e81a7d8d37037"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "054a54cad6bd08f31ea9350497aafd5f7c180f6ef1ba04b180f9163385463f70"
    sha256 cellar: :any,                 arm64_linux:       "53277bf9c13e85c69e033e9f36ce2adf4c37abdf72af5c68fb26d8fe4e4296c8"
    sha256 cellar: :any,                 x86_64_linux:      "0a906afa8a3c78b24fe104c79fa727b6881e10a7148cb567e1af24ff27d9342d"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "usage"

  allow_network_access! :test

  def fetch
    cd "ui" do
      system "pnpm", "fetch"
    end
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    cd "ui" do
      system "pnpm", "--offline", "install", "--frozen-lockfile"
      system "pnpm", "build"
    end

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config

    port = free_port
    pid = spawn bin/"pitchfork", "supervisor", "run", "--web-port", port.to_s
    sleep 1
    assert_match "<title>Pitchfork</title>", shell_output("curl -s http://127.0.0.1:#{port}")
  ensure
    Process.kill("TERM", pid) if pid
  end
end
