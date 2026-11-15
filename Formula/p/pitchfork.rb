class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "4e85f09420d16fdefc94da42015347f163dbf8e0b9c50fe8b216a77cd8e1b989"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d1512c0009dcfa6fae9d6a03946ad561e2d5be203c4fa5f3d18fa4adddf5b35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2fde615ab21b1792b29fe00438ae541d078497f92210161ed70414f28d1bcc66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cceda938e196e19cd83de58b4256c4d0d9235ee4ca456d9881521df52463562"
    sha256 cellar: :any,                 arm64_linux:       "20f1ca614c4db593f2e7fee10c8ed58a414352c848e1f8ed635cdd3820db1e46"
    sha256 cellar: :any,                 x86_64_linux:      "84e76e7f3e6d27f41c5db81cc7d2f4b0d2ec93772755f8c39f5e5982d1adb101"
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
