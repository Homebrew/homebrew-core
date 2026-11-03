class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "b91dd4fd0662c627499adfad7c6f1ac90c3429b865d1094a6a2e6cee8eb488e0"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b05825d9ad9087c6dc905e28d5536ca18efda5634eceabfee91d88f40fa0e56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8dd540e85bf08ee7b40e21772629118d5b2837b0c6a514aae00f8eab52af7bf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66640af219102929f7934d59ad7c4b979b55cfd16948a1c3af7cde599c065b9d"
    sha256 cellar: :any,                 arm64_linux:       "d57864694b811e763dfc5a1f6c8edf75851090dcb2892f1e145e4911e8086f5a"
    sha256 cellar: :any,                 x86_64_linux:      "9cf86dcbddedf5ddfa9bf58866d06ee2f3778a001b842809202df1d91e65b7bc"
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
