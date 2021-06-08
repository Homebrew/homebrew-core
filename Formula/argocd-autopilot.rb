class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.1",
      revision: "5118ac57e1d92781e64eb28e87f163798f0dbbe0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "865df437e3b3261d392cd50367309d93b4af20f84b25191b622e78db4a79cd0c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4af58b05cb84c1b58074d0628ee770d307bc38b46615890770ebc453ac80a79d"
    sha256 cellar: :any_skip_relocation, catalina:      "1e6d396daa3417f9918585c75fdd4056a487702cd405a8958473053c4a064853"
    sha256 cellar: :any_skip_relocation, mojave:        "3ba183f20a139f51ac6f18f18f86a142c6715a3289887d0ee7c80c311b91d0a4"
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
