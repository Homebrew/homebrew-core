class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.5",
      revision: "0c5be8c0460d24a41aba21c3988f8cd04e952ba2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd12589789c7dc6fdbc92fd667fa300c3e6e24ee4574ff10f888bc988663f97a"
    sha256 cellar: :any_skip_relocation, big_sur:       "327b26b18ed86bb418437a829a7d842136f4c2c55a650682878e0ace153c2ca8"
    sha256 cellar: :any_skip_relocation, catalina:      "7bae8cab204e0e79fc6ac101d8912589d4958c186672c733d765be8c1353ffaa"
    sha256 cellar: :any_skip_relocation, mojave:        "7fa97af2e1716987bb37bec4a37a278c892d8ad8591287a6acf67cafdfa416f3"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")
    assert_match "authentication failed",
                 shell_output("#{bin}/argocd-autopilot repo create -o foo -n bar -t dummy 2>&1", 1)
  end
end
