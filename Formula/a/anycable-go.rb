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
    manifest_sha256 "73f4c4c325549476760a736ff9669e3b65cd685e49ac52b6e6d3cea0e5c39148"
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
    with_test_process(bin/"anycable-go", "--host=127.0.0.1", "--port=#{port}") do
      output = shell_output("curl -sSI --retry 5 --retry-connrefused --retry-delay 1 http://127.0.0.1:#{port}/health")
      assert_match "200 OK", output
    end
  end
end
