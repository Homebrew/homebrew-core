class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.1.1.tar.gz"
  sha256 "8554219df615551f6c8fbdb9c76b21f5d23218c611d5ef4457122ea12da5d586"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40037645b79742bf30f000b59cc286ea288393ffd18e59bf6887683dbbbf7ea1"
    sha256 cellar: :any_skip_relocation, big_sur:       "79168fa72bf0c48b93b99c5625e24c78073dc3d8eb8289e8c80f610433169628"
    sha256 cellar: :any_skip_relocation, catalina:      "d430743932cb0cd6d93f9d87e02bfff97d8192cb26eacfb1989622b55b44375c"
    sha256 cellar: :any_skip_relocation, mojave:        "bc4c5071169c208e5c3d146aad38c7a6154e374b49d4e9274a62b9c7b3dbd1d0"
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

    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args,
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
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
