class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.2.0.tar.gz"
  sha256 "d8d411e078f0e3de754623fe4d68025d60c8a9fcd31a29972d8c2f72d2a8d541"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb6bea87e378580ae10593bdfbf55b4a488348e75d29ae354461bacd7245ded"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed7c9befcb24175ed31dced0fb7cbfc24c6afc8b878f236a9a84819ef259eb98"
    sha256 cellar: :any_skip_relocation, monterey:       "fd109c24e5407068d5352fbd8ac7643a62dcba47a4c1f44b215f880a42c680ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "73fbdd129544f14df687c4f77d60d8e7ee66c008526f2e184065eeca18215624"
    sha256 cellar: :any_skip_relocation, catalina:       "67acf8def8551f823001dc792ccf81fa145179cd526699d3783c85a7cbbe9320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335920268709ce85f3101047512f67c320415783913d9de8eb3c735bbba83bd9"
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
