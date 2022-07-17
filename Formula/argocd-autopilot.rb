class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.0",
      revision: "ac20375044087d646da4492854317322396e769d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56733f38b70cdc80c85e29d2b65167a05c254dd24457e87626dd81d5790ecbb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621bae4fe3c9bded72e9b717740780eb3f4ea25d6fc21ab735c6908a36927610"
    sha256 cellar: :any_skip_relocation, monterey:       "111491d7164474e4715c67e9b343530f2b8bd62e1c31932d8f54ba19f6b7542c"
    sha256 cellar: :any_skip_relocation, big_sur:        "926807552bf28234825f310d2b4245ddd32cda5f1f16bebc8067355cbf3d72dd"
    sha256 cellar: :any_skip_relocation, catalina:       "fc50f3ebf08f1196368832d956a227a5a92dfa1611ecfa3fa22324b1c39d00e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa0ae92c125cbc4860afd1f7724b0309e9dd76df881ab58649ca41de5043d5ac"
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
