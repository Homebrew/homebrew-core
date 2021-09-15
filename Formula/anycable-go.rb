class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.1.2.tar.gz"
  sha256 "4df04424a8e9ed54e7a8f6794d0de7ff6e66a4b008d7e477c5434bd70dcee5da"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5bdd66f06bb0ac31df254482c903d552792183665092c618508d30ee16598028"
    sha256 cellar: :any_skip_relocation, big_sur:       "19f2fdb065fb764dc1301b3c60d63e3831b0edfe6958b17bc4b47677a5b55302"
    sha256 cellar: :any_skip_relocation, catalina:      "54212b45fd6fa767cf47eea5864bcd2af78cffb6444165737ed4db913b2d5af4"
    sha256 cellar: :any_skip_relocation, mojave:        "36dda5259c67971aae789e6952858135cda3fc79bd07b5f2e310ce99622e9af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58215768e7b85dced8f35809d93e7958278ff1816f374d71fa43dd52cb0af928"
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
