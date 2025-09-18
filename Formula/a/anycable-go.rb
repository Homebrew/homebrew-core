class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable"
  url "https://github.com/anycable/anycable/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "86cd32e7be5c1ae369022992b6256c3d46f5b22591975827b3c5510484c69847"
  license "MIT"
  head "https://github.com/anycable/anycable.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4debc12d24623d3d5dc4750cf35bbba5b29f4df4d2e5e2e3e6fc99dd065b8e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4debc12d24623d3d5dc4750cf35bbba5b29f4df4d2e5e2e3e6fc99dd065b8e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4debc12d24623d3d5dc4750cf35bbba5b29f4df4d2e5e2e3e6fc99dd065b8e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4debc12d24623d3d5dc4750cf35bbba5b29f4df4d2e5e2e3e6fc99dd065b8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "51e5021b752d23a21b698bdc4736fdc02916eb1e38308639616b3bb127f95a4f"
    sha256 cellar: :any_skip_relocation, ventura:       "51e5021b752d23a21b698bdc4736fdc02916eb1e38308639616b3bb127f95a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2846874636aabc08560346d566844448331ba2107ee32e4faeb88e952c9f8ab1"
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
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    sleep 2 if OS.mac? && Hardware::CPU.intel?
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
