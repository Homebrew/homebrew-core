class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.6.1",
      revision: "346a7c41c8041f03c553690eb2ab61d2db3e8742"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbd5a15c710f28d1f481ce428cc01217fc2e92f915174eca7268f666cf4e5e66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90d2cc3ac15f59db62ce8d719ceadd6472e102237a87c44490f0b8f0fefac6ac"
    sha256 cellar: :any_skip_relocation, monterey:       "da4498ec238aeadffcddd85c6526fdf946df6d16a9d3a165b9357d2b38b34beb"
    sha256 cellar: :any_skip_relocation, big_sur:        "58a3dcd79628e4111bd4fc88c42eccaab8dacc5fa01983de6e0957cf76add227"
    sha256 cellar: :any_skip_relocation, catalina:       "a38eb8df5861149a89b7f400e5d226dd1d81357e497a3be7a4eabbdbfdfe6a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b31e7cb7664d21b7d07dcfce7792b8693c9c68bfa306128a5ba312f60b58b15"
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
    manifest = "https://raw.githubusercontent.com/kyverno/kyverno/1af9e48b0dffe405c8a52938c78c710cf9ed6721/test/cli/test/variables/image-example.yaml"
    assert_match "Policy images is valid.", shell_output("#{bin}/kyverno validate #{manifest}")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
