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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "146b40ad41d074fc81a1cb55db50b02e27c2fa581052e6db2e822e27afa4917d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fc0d49b3526cf90d9fe6c0cc8eeeacda272ab51a3c83fe11923d51a66c8dfda"
    sha256 cellar: :any_skip_relocation, monterey:       "506079d7623dd8f79fd550d305170df926e7b99655ef9011c610696d6703a1fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6a40a84324503da1dc92ae7d3425e0a55e81c9fc3bed620992ac62e04342a25"
    sha256 cellar: :any_skip_relocation, catalina:       "417a92a8f0f109f25ae529cc6a054d481c58896019c45357a0eeb0add4a3334f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59acbeac6a1877674d1f1b0b74595be99fa9afd0d7a24bbfe208d33642ed8529"
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
