class ArgocdAutopilot < Formula
  desc "Opinionated way of installing Argo CD and managing GitOps repositories"
  homepage "https://argoproj.io"
  url "https://github.com/argoproj-labs/argocd-autopilot.git",
      tag:      "v0.4.18",
      revision: "d31992f1b38477ab3eac4ec2e713cc084162b379"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e264fda7b7cdfd11e1c97e5d65f3fa3e92a8cd7bd9c24d64742dabcc3a2550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e1433ec1f8bd6fe6f61cc958c4b0cca0b36711306020736d57284c7d459c463"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fe51fee4bfb2d8c3a97fb6b33c7629eeb3de8c3982549968b9c5bd227c12394"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa00c37106e71058a81979c4865c84d86767ebc369f6dacd8e4243cd3bf0fb91"
    sha256 cellar: :any_skip_relocation, ventura:       "45beeb24b665e842671896611f203e6ade77c2a54c607efbea3fccc057e50c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd05020a5fe05d0c5704a0297edd844e6302ca88e332df7c51c851cccb93cb3"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-package", "DEV_MODE=false"
    bin.install "dist/argocd-autopilot"

    generate_completions_from_executable(bin/"argocd-autopilot", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/argocd-autopilot version")

    assert_match "required flag(s) \\\"git-token\\\" not set\"",
      shell_output("#{bin}/argocd-autopilot repo bootstrap --repo https://github.com/example/repo 2>&1", 1)
  end
end
