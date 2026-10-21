class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.32.1.tar.gz"
  sha256 "5408a26c6812399acd7112b42ee5e747cd6c8b1c43863257340f2e32c38b1e77"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "712d0dfade7d6bd04977826d854000dca41b05783a3bc259180a2cdb8eff6dcb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7c5cf5ec4ca69fe0aeb6dfe6a1f3c9f84b693451b4ac8be0f27020760fab7d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e1b752a81e348eac16e055e85972295a94766dfb7b0b6b410baedae11020d6d3"
    sha256 cellar: :any,                 arm64_linux:       "2531d643398a38dceb1f2bc06d71997831deb5007ce74017e26e77f2fdae8a45"
    sha256 cellar: :any,                 x86_64_linux:      "182d48b2d0f35a86d8abf14ee67b65ca261bd69e143112db4f0f056762536331"
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
