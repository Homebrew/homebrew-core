class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "b2e41ca58f46aef9e79e476063efccde6b59fe08113dde6990f7a696e9f0526c"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7c6b921e02f1d9cea9c1eb9f0880c3c60079921a02775d80d4413f33095ed777"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5967994c96944170b4880cd27247f64adda5beb132a878fe9a9d1ab168129cc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58359272309699d645fd033138dc0e92e06f0a342fc4694fc4eaa1fd15573723"
    sha256 cellar: :any,                 arm64_linux:       "cabdd8e6a1769f0cdc2a63e48147c55af7aa8deaee300013f349337288d30ea9"
    sha256 cellar: :any,                 x86_64_linux:      "619b4917156da399e2f67c10485a558edfd84feede8f59ce2f8e9d7f2383399a"
  end

  depends_on "node" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "usage"

  def install
    cd "ui" do
      system "pnpm", "install", "--frozen-lockfile"
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
