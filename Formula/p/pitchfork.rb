class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://github.com/jdx/pitchfork/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "5552b3c6bafabcd0864e3e31b5bde527f934ebb46746d69e55d911a6366bee98"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60d88cae6877d48b57b7c3edd6749e4d5ac7f9319b0d1d9b1a4eecb46d306653"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8fc41c32c35639ed93a1addddf74b2a2c210075e0193b7b27f7a10b0775cb87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a713745c60b8a71f810e3b2bf540f4b0651d5dd4d8c12a5d239d79453a32836"
    sha256 cellar: :any_skip_relocation, sonoma:        "25d52759be3e416a5d3c6042d21ff94c4cdb87c9fc846bc71aa6a0b22f0ee766"
    sha256 cellar: :any,                 arm64_linux:   "88b49ac409ed8d9d9aaafc7b4a823c63c4bd9032df16fdd03793e49940fefbca"
    sha256 cellar: :any,                 x86_64_linux:  "1e5e67678ef81731ee6d81cff7f01d83568c9d4a93df56710695c10e60bd8699"
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
