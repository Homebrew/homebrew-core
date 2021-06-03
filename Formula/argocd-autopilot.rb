class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.1.10",
      revision: "646b3faa598281d0404c4b85443361597173c6c7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d0cb9353327224ee04332921d5acc88155d92a58d3f33201959e9a3b13d89ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "331e8fffb55e6327fc60df586246be84e1b9c1cce2dae94e5c3e0d4ff511f807"
    sha256 cellar: :any_skip_relocation, catalina:      "e183527bbf7b27b290efe4ae9a73906bb72713b4190b3193f991b92780443272"
    sha256 cellar: :any_skip_relocation, mojave:        "8e52e84b3fd240a11e990afad06acc70650891321aaef3b599a93105b76b29d7"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")
    assert_match "authentication failed",
                 shell_output("#{bin}/argocd-autopilot repo create -o foo -n bar -t dummy 2>&1", 1)
  end
end
