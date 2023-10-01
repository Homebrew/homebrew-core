class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.4.4.tar.gz"
  sha256 "8a6cd528f8af57968ef55ec478d2cdaeee020cce37588e5e6431d3dedcbd9c7e"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b64ef4b6c5100f948cc1d34b48f3fc140dfd885b0763b840b3557a2a1ab9063"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cb16701e93081f681a3eda8b637c8fbd930c920b120f5634124d760e831c12b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cc60eb2365550d70312bcde1ed6a8a9124055f795a6e4aeac571c90830527ba"
    sha256 cellar: :any_skip_relocation, ventura:        "ec36b2f1052410c22c237ec649bd745e3caea6e29482d4f512b42f3c72674214"
    sha256 cellar: :any_skip_relocation, monterey:       "23e46eb00233427a8b9c31fd4179af1fde82276cc261604c61c3de344d9d7db3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f759c3ac589024d1b3b41ad032e35e617df6e075c1cdf3d60ec98acd842894a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0cc9a17dfc94c18dfda06d3a05fff9d289548059272089c32023fe3d147da72"
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
