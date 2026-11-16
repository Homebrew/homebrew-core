class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "522d736b87a0a2a99db698f104352e58a8fdc9e8ed76ae171ec7e3a2605f9dad"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a4aab356dba00d0ad216a30057480b7ffb3d134e1b5f5d12f13dbbc299b25a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc8d984f1b86ebf2d002f41903df656fa4007c184a67194abd73727ca1b4cb26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "941043675a674a667c3b7de3ccd32b8695829cc198d9d3bcda412f2efaf67c83"
    sha256 cellar: :any,                 arm64_linux:       "ee9749992b3f7bba51d4b304a352cea65c7c69b0688d4a1ca6ffb0ada1a720a9"
    sha256 cellar: :any,                 x86_64_linux:      "e47dd339b37ecc1283a9a5e2ddb449432446e0c007841f5649e40bd406b47ef1"
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
