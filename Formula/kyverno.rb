class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.6.2",
      revision: "4b2bf039f6f04cc02cf89dae7e15f8bc17b2ad78"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a953939ea3e2acf00eb86a5f5d6fd3206153841ee852fe3eacc23cb4f665c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a323fa4a327e5182210838a052f30526bb96abb9bf0b3849bb63ec58baf58c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a07e5820c7e48bd57f90db20f1d897c0c2b81539727ba9dcf90448032a1fb2f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "befe3eeab69707e4b9348f8f853e4fd6c9be2e9f3763e45fcbb81eeb64ffe6f9"
    sha256 cellar: :any_skip_relocation, catalina:       "64e3185bd439913aa21eaa4d1ecf67fba6972bd0fc1fa347b9bf08f26137cacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa67de4a7686a106f55e6fadd0b78108521209e1298db93d83a6d6036c0a0c4"
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
