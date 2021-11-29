class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.1.4.tar.gz"
  sha256 "a9a4afe32d7d8269dbb0f5f4aaaa4b63710e4193ccc757877f5be66a5854a4ea"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b726157cdfbd5ec8a52f64a79f31d56b17087102e0aef4e14a1c68ab102171e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea4de387eaae1a0731e3e5df76455ddd027e76f5cd8d9d313b6329622821c6c"
    sha256 cellar: :any_skip_relocation, monterey:       "107efe7cb0d3ed62a8295bb28602a4bd6e48fc8d42e37a84c3c128abb9a35d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d22bec92d9c266febeb88cb4729922444917d560d96aadd9b706091e3decf2"
    sha256 cellar: :any_skip_relocation, catalina:       "6764ce391e0e78cd115890d09e59021de2a3aae9a71902eed4d730f68ecb2b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730c420e2b9805d6fe56873c6cd1c3bd8552a139783dabf56a685c736cb04a3a"
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

    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags),
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
