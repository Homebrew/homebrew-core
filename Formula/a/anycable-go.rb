class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.4.3.tar.gz"
  sha256 "e2c34c966e3580c5003d46c72a12ee970d87cb56163cad575e2184f28ae1fb5b"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c24b709659d2ebfd8eb5b351f180364a85116868561a290ded690eb3c6e0a801"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24b709659d2ebfd8eb5b351f180364a85116868561a290ded690eb3c6e0a801"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24b709659d2ebfd8eb5b351f180364a85116868561a290ded690eb3c6e0a801"
    sha256 cellar: :any_skip_relocation, ventura:        "d5b3ed8ac3caa88355f734f3558deaa02ec189df4bda4c9ac766bc4fe1cd19ab"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b3ed8ac3caa88355f734f3558deaa02ec189df4bda4c9ac766bc4fe1cd19ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5b3ed8ac3caa88355f734f3558deaa02ec189df4bda4c9ac766bc4fe1cd19ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61b5aa42ab8b0917f12493547ac92a3b241c14a17c9935f00e45edbf37d671cd"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
