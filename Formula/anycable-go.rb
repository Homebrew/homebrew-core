class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.1.0.tar.gz"
  sha256 "6f56db42246e32667b5004a51f8df6fb28f755ce8841c2fc9d1294d76ef3e2a9"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0324875fd4b89dd24a66d40c69ac2548a4ffe085929c9c32dc8c601f1788436"
    sha256 cellar: :any_skip_relocation, big_sur:       "55db3c39deed5d7ee704357684a28e973a8b7692bbc25552965767208f08cbcc"
    sha256 cellar: :any_skip_relocation, catalina:      "2c664028c8a384f6111c84eff6a6b6a22baed8f4c6927be02a6f46234e16849f"
    sha256 cellar: :any_skip_relocation, mojave:        "82f514209c37947cb9df479ca455b9ee3685fd194b3f92c350d152ee638a7f5a"
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
