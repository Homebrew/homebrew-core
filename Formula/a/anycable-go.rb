class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.13.tar.gz"
  sha256 "5595bb021b6a48c943811972a1a75362c4fdbc6040414eb9366c548770d4cc2a"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eefb3596c0ca76dab65b8f1cc4b95038abcdc701ac819f9c5dca4d6f58630c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eefb3596c0ca76dab65b8f1cc4b95038abcdc701ac819f9c5dca4d6f58630c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eefb3596c0ca76dab65b8f1cc4b95038abcdc701ac819f9c5dca4d6f58630c4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e04ed9c7d7a852680f63f4ef7014caf29dd2043124bfa408ee748fc3fc00a35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02d1500c7ff019af19d2c4483320daa7bd39e2e80f67e4849d22c3f0bb1ef5b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f4893f0a7ecc46a1a031447cc662f5e494dcba085273d489a8369b70259563a"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = spawn bin/"anycable-go", "--port=#{port}"
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
