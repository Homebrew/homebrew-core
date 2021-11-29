class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.27",
      revision: "a0f50e11c7a93101e28d1e3bb5b6024aa528e681"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1dbfa3131758fef0d58e6f18f7e3193fa1321bece655c01b7c9674ce6a6e9a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d068cd2c3421242b3727ee8a5ae46b8315a60cccd041d6b2c3002cd021d15286"
    sha256 cellar: :any_skip_relocation, monterey:       "1fc2ef01e0eb8765f78b95aca73012c0e373089e3ccb95ea7f15a9bb7d4ef513"
    sha256 cellar: :any_skip_relocation, big_sur:        "21ca2087bccb225f086662ceedeb56c4e68fb69c385faf84491e477fb35d8220"
    sha256 cellar: :any_skip_relocation, catalina:       "603beade75ba856795d804877a12e0097beb36a95dd82b0afb7e57065ecbd001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9469ab6502b8025e4ebeecb53e4c6a35b9b0dcfacb52df65db6f16c73b47f4"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
