class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.3.0.tar.gz"
  sha256 "efeae8220a82fa16bfa2c2eacd1e272e82443dbff42f2f2baa43bc70c2c870b0"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f3d878bd3dc456f1f0f067719c15b481c8ef826e8fa4c195665852fc5769199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8669518ed7bde73c09d0e71513ea04ff00eb85c3b223dfdcd829302b92e58e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6c58f512bb91934c77af6afd55b2e2af9364e705b9cb8403b617b5819f9ae91"
    sha256 cellar: :any_skip_relocation, ventura:        "7a0a30556128ca6e777f370a5dcd1d71584f0458a371de6d47defd666bb13be4"
    sha256 cellar: :any_skip_relocation, monterey:       "dd32f72aa1acfa7c2ac17b6cf88d7214ec059edebf4b870bd228a207227f8d80"
    sha256 cellar: :any_skip_relocation, big_sur:        "63a7380ec5901602f4a84f53ed4fc0194f975664184a4a1800dd197cb155124f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d07c6c71cf5cd7cc7be705f72069b65bc286db77e58a21cc0e5a9faf9d62d670"
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
