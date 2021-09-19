class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.1.3.tar.gz"
  sha256 "2229ba29782f71b5f7428a88d5599c33ffe223c148e32e000d3f0f505427c01c"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cc2c4cf90b5b993502fc9199deed645c82034fcf0c89cc32abd90499583e58a"
    sha256 cellar: :any_skip_relocation, big_sur:       "9cfcd34dd576979ac4b61479be2e6cb0768a8f91220ed1186545dec372718258"
    sha256 cellar: :any_skip_relocation, catalina:      "f1d879be44533a9bfbee54b30b0a5418299544ffd92a124176f62e1ec28489e5"
    sha256 cellar: :any_skip_relocation, mojave:        "b537ae6c62cd1ed8fad1bb6c7b2238423df93158e6e11c8c2e8cddb2197aeba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f56dadd5ec3a0fcf20afbec6164a8653b3252bd223f394a72580101b1fa98e2"
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
