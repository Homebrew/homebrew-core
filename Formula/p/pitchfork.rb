class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.33.0.tar.gz"
  sha256 "bf5116a058ad39364b96ab80598c86d1061415d192f7be18af34f37b501a7857"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2524337b7848d39b1e5898ba52edb7280ea3d187e310a1fe4bb67ca533bc0924"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aa6e4de34ad0eab7ba74d55e0dfd5dfced468ce840644d92dc53a4305b1c84fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "568ff76e5363d091e208c659127fa725bf9116fc58d67b3aa68144eaee3a58ab"
    sha256 cellar: :any,                 arm64_linux:       "b60fc25248a4010ab2e0287303a16e24c4a7f718d1bd2bcb8ad8d405b64cf897"
    sha256 cellar: :any,                 x86_64_linux:      "5876ac0172ca8e446adb38cd455c80ef31140c6f95f701cb25036e20f6cec09c"
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
