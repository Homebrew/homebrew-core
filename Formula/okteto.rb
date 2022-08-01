class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.5.2.tar.gz"
  sha256 "6eebe6e5bb7ee5f69c1fdca28dc6d334298a84e39291b9a6f6db0d4a73a66ff0"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e6f21999d74ee618ff4f49e174528bcf99e5d60446e5d231e0271779b2163d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f81ebb55a9c04a5f9f6318add76cb6d9c0b2432ab3512d1652aca49746d9f48"
    sha256 cellar: :any_skip_relocation, monterey:       "ce722fe3dca80e14e6e11977e4c5768e514daadab675031a6fa2f09bb31796bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d311c09966bd8c5a97f64c09a22eeffa93c5a02b357f1040b2ef255402a611eb"
    sha256 cellar: :any_skip_relocation, catalina:       "eb4f33de1a840fd884128a76e787058ea7db1977acda0310ea2b08d5e75cb32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1663259e38ea4e9731fe0fbe95f6150b399da2ee9c1691792d33646201d6be4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
