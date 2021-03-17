class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.5.tar.gz"
  sha256 "3fd4bef8732a7db0a0549b9eefd9f1ce2d295e6fa80e203bf68d6ffbcde2385a"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c4c8c238d753be0f866f7d1c32ae8659fdd333100811059f439e5d9c9a1913e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a83acacdb916bf040de062a68ee718f53b54573949644a343a74a75009e3bbe7"
    sha256 cellar: :any_skip_relocation, catalina:      "c7326e1e3a9647f8729e9577c2a2031298248a57b6dddcabe214dfd378d7f072"
    sha256 cellar: :any_skip_relocation, mojave:        "c68cc99c845c2482a4c73af9af9fab61212f1e324a643a6afd0ffda898f1afbf"
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
