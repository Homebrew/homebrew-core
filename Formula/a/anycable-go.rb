class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "309cd07cc50794fa4527aee20ff8c9441e1a496ff2abaa7659bd5f783e4e0b21"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3925cdd9fa8894e17824e6c74c863200399904101cde22519608940a74dc37e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bfb773c7d5f61a62a7711ef0d480c7dc542b480a8308e2f59b7e16f1aaadd8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1e886e7c219935e4ff37470ffd17e07d9a7f82bc1b19bf3560128a04e94c0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc9482c3418f3eaea175b972b35029196712d5d9e3834b62a6eae76206d2e7ee"
    sha256 cellar: :any_skip_relocation, ventura:        "aea47ae84b6a20fb4a33fa6591e1f5779d591daaf52bf463caa5ab22cfae0f01"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c108eec85a868f5fdec6f188216b6aecacffe15d32433650bddced31c21fe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cfb3711af0717a7b00d86006587cbe7fc05a539b5f803049525740bd6e883cc"
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

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
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
