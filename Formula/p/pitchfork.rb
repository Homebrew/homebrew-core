class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.36.0.tar.gz"
  sha256 "417384ab9c521f9591fb45d6948c857a28dba4a75a07be59e1c38fa5bbf836a0"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    manifest_sha256 "73dce361f0048f1255d52b7dfa35aaa3f40d15790c7f32b697289941cf1cb88d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddc8dd6618c83e8f961525d666f5ebc9762caac73f1f4d8d94d0d5698aa7a656"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5be923d1d3f34f9d0118216879317e24887959138400dd5dec267f92f8bcec4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "878dc832ed77a6a931ec00e648a12e2918e8ff4d92f80b461fc898c1f6eeff53"
    sha256 cellar: :any,                 arm64_linux:       "1044d5c61b55b58120c7c3c9c9fe9285d96136ec5bb6f723cce7834e75f0ad78"
    sha256 cellar: :any,                 x86_64_linux:      "c9e7092e11e5568f2b0ec2e4b843d282c3362fce5d80a9991202af90579dbabc"
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
