class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3fe63f2970ae99e59309a579d5d0bebd1f1b8a6cfdc0117f3d3c7231d8b6a7e2"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fd2b94c0246c12ab9c94ab71bde270d18ce70094ff72a257ab3b1b06ec7d0e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff752d17acd7ad99d43ba094af7430509f11bc6c42c7a57bb57195bf7defd7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41235a2ac3e4b3c87265d616f9c002a00eaffa0b9251bc206953ae1e28ab752"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2a010c9385cfc3a5c63ff8427a753c2f56a8942c7c92c38dbb7beac40e05ce0"
    sha256 cellar: :any_skip_relocation, ventura:        "574a6ad159c51514e85518bdc9c0403080ab37dd18be72148fd928d105b06e34"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f51b5e08412b5d3111573aaf0951822bf6ed0cf98b1579305ec0f78101910d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8d6980b634a2417a261af82ad0cf463c6f4c6f95c12dfa5f109c1acb0246f5"
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
