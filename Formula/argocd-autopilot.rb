class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.2.15",
      revision: "872bb4fcc1dcc4e20ed942c8a0b5da36ad044b7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac29047abdb327f6cf7de878668808ab5c1cdc5b8b87b1e18408866ae2855008"
    sha256 cellar: :any_skip_relocation, big_sur:       "862a097663319007ad64257d94af913b8743804b0400710ffc96b2ba8a09ab44"
    sha256 cellar: :any_skip_relocation, catalina:      "039ddeb46101112a737cc608026da9f85a577594472f632859777662bf4ecc0e"
    sha256 cellar: :any_skip_relocation, mojave:        "86abe7cac904945874664d9cd122547a11cd24db854d432feb6079e88f590b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0558a50ef1c7ff97ad06f809bea87f1eb259c1dd9c792ca8d8be5607b55713c6"
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
