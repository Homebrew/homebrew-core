class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.7.2.tar.gz"
  sha256 "b89e4e585dc44936b921e04650b20832d25ac456242f763d812bdacac5a6a0ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a20fd1730fc774784296296440d65b853364bb6b9b22c1b4cd3db407f95a8992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69cfa5a27ca2ebd4154a829929d57388a5e85b6bc78be426074ebe4ac3512cfb"
    sha256 cellar: :any_skip_relocation, monterey:       "bc788186a52c9745ba73e4f8488fe9625a53c834509b5abd32a49201b4177679"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8c55957d5010ec17f3db5345fbfd86ffaee2b38bd375cd0079fce2d3720b025"
    sha256 cellar: :any_skip_relocation, catalina:       "d367e6d3f6114c51a80229dc07a78b73ee481c5b69ed136c0264fc5dfcadceaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a300ec1c69afd6524f28d4871f20349aab1f36581d0e814429ef7b3315786b07"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"ctlptl", "completion", "bash")
    (bash_completion/"ctlptl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"ctlptl", "completion", "zsh")
    (zsh_completion/"_ctlptl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"ctlptl", "completion", "fish")
    (fish_completion/"ctlptl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
