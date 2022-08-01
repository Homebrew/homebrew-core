class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.7.2",
      revision: "420ac57541a3767f052d57044f636b17d9e0c346"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbbd5e627800008a21c99cc9cec750e54302b80c0fa114babdf0c28147e20d08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cb923db0a5f94dbfe0201c4551979baaa648af050218b75c9ce1720f41d9cf6"
    sha256 cellar: :any_skip_relocation, monterey:       "d4df47125ecec5c213d5efd7697ec2d29d35687c2f22a9d9e39f7ab4fe80b4f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c28cb311b484a951a281d3429980dd5c87014d9c2d4c97e731103663f9951be"
    sha256 cellar: :any_skip_relocation, catalina:       "b5e57c8aeb4bf9a739742252f701e44299051d3617b03c13719a1b058c3ffe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f47a6c0601e7010aec373bbc95a73a892af29c5eb8301af989716d29db46368"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    (bash_completion/"kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "bash")
    (zsh_completion/"_kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "zsh")
    (fish_completion/"kyverno.fish").write Utils.safe_popen_read(bin/"kyverno", "completion", "fish")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
