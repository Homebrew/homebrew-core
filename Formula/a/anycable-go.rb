class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.22.tar.gz"
  sha256 "6f3253a90a64b6cc1be1b7dd32a734d3f74f34be7060357a7314b9bc1b6e1190"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "68623a997a6f5cd74192366698af773e111e71d46e3f333ecff41d16f682f1e8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c86e6d6436b0e9743c13bd7adf0540afd866e1ef79afa35d718a72e6fa78562f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c86e6d6436b0e9743c13bd7adf0540afd866e1ef79afa35d718a72e6fa78562f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c86e6d6436b0e9743c13bd7adf0540afd866e1ef79afa35d718a72e6fa78562f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c3156aea81cf632120205e14f55cd6ff31029441596c6a233bd4ed6da149e6f"
    sha256 cellar: :any,                 x86_64_linux:      "e56b77e271599372cb13a33c7ae0fb54632b42590e6ab9f8c2274fd2e27a7581"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = if build.head?
      "-X github.com/anycable/anycable/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
  end

  test do
    port = free_port
    with_test_process(bin/"anycable-go", "--host=127.0.0.1", "--port=#{port}") do
      output = shell_output("curl -sSI --retry 5 --retry-connrefused --retry-delay 1 http://127.0.0.1:#{port}/health")
      assert_match "200 OK", output
    end
  end
end
