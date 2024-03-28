class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "9e3e560975e1e377c95c023054d30e10c8209e51e23d92a7a3fc2ec1aa88c6a9"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "687f8b584e22b20c347cd0db08cf306e260f3008df4d1e25bd4e747836e11955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4abc15cf7bc3116daf5c31ce9050d400ccb8ae04590607e7bc2a306791287d67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ee13cd127cda02afa8ff38428c75cf870b5e9a2e3fffc4206ef08b3b412edbc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2ef67f3ef6a96d95817ba2b5cfadc7334ad4e725ed9855c6d024ff8bc15f1f0"
    sha256 cellar: :any_skip_relocation, ventura:        "9e5359e0a3995f6e06d801e7b08f4d920889285a096313d656b1f0b4f8d911e8"
    sha256 cellar: :any_skip_relocation, monterey:       "425ec40bd4a938d0fe51943433e85b84edaa2cb75b4d1ad65d09d69bf54e4fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e8ec19a523662a6f120e5f5850968aba40fdcb3c14c51619e1c92fc81d75d0"
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
