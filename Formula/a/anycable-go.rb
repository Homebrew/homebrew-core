class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://anycable.io"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.21.tar.gz"
  sha256 "af9cc9a79e758e4ee125bd6d74850fa747817da205c69fe0ecfe999fe06a336a"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "931bf9f1b9813bf6153ce88d18e7cf52385abd052176cea9ab5d7a90575cd4b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "931bf9f1b9813bf6153ce88d18e7cf52385abd052176cea9ab5d7a90575cd4b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "931bf9f1b9813bf6153ce88d18e7cf52385abd052176cea9ab5d7a90575cd4b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7ea916daeb4cf3d5a3b613f4c5740018f62911265e49ee6d00ba1cb03efe4d36"
    sha256 cellar: :any,                 x86_64_linux:      "26fb9eb514b431e11509a9fda678f7826f2dbc85e1645d3e1e29051bc1720b89"
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
    pid = spawn bin/"anycable-go", "--port=#{port}"
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
